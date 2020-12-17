require 'oystercard'

describe Oystercard do
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journey) {{entry_station => exit_station}}
  it 'has a default balance of 0' do
    expect(subject.balance).to eq 0
  end

  it 'allow the user to top up balance' do
    subject.top_up(10)
    expect(subject.balance).to eq 10
  end

  it 'has maximum limit of £90' do
    subject.top_up(Oystercard::BALANCE_LIMIT)
    expect {subject.top_up(1)}.to raise_error "Limit exceeded #{Oystercard::BALANCE_LIMIT}"
  end

  it 'deduct fare from balance' do
    subject.top_up(Oystercard::BALANCE_LIMIT)
    subject.deduct(Oystercard::MINIMUM_FARE)
    expect(subject.balance).to eq Oystercard::BALANCE_LIMIT - Oystercard::MINIMUM_FARE
  end

  it 'in_journey? should be false as default' do
    expect(subject.in_journey?).to eq false
  end

  it 'touch_in sets the journey to true' do
    subject.top_up(Oystercard::BALANCE_LIMIT)
    subject.touch_in(entry_station)
    expect(subject.in_journey?).to eq true
  end

  it 'touch_in stores an entry_station' do
    subject.top_up(Oystercard::BALANCE_LIMIT)
    subject.touch_in(entry_station)
    expect(subject.entry_station).to eq entry_station
  end

  it 'touch_out sets the journey to false' do
    subject.touch_out(exit_station)
    expect(subject.in_journey?).to eq false
  end

  it 'touch_out stores an exit_station' do
    subject.touch_out(exit_station)
    expect(subject.exit_station).to eq exit_station
  end

  it 'has minimum amount of £1' do
    expect {subject.touch_in(entry_station)}.to raise_error "Please top up"
  end

  it 'deducts the amount of a fare when the user touches out' do
    expect {subject.touch_out(exit_station)}.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
  end

  it 'remembers the name of the entry station' do
    subject.top_up(Oystercard::MINIMUM_FARE)
    subject.touch_in(entry_station)
    expect(subject.entry_station).to eq entry_station
  end

  it 'journeys is empty by default' do
    expect(subject.journeys).to be_empty
  end

  it 'touching in and touching out creates one journey' do
    subject.top_up(Oystercard::MINIMUM_FARE)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys).to include journey
  end

end
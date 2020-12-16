require 'oystercard'

describe Oystercard do
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
    subject.deduct(10)
    expect(subject.balance).to eq Oystercard::BALANCE_LIMIT - 10
  end

  it 'in_journey? should start as false' do
    expect(subject.in_journey).to eq false
  end

  it 'touch_in sets the journey to true' do
    subject.top_up(10)
    subject.touch_in
    expect(subject.in_journey).to eq true
  end

  it 'touch_out sets the journey to false' do
    subject.touch_out
    expect(subject.in_journey).to eq false
  end

  it 'has minimum amount of £1' do
    expect {subject.touch_in}.to raise_error "Please top up"
  end

  it 'deducts the amount of a fare when the user touches out' do
    expect {subject.touch_out}.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
  end
end
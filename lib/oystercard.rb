class Oystercard
  attr_accessor :balance, :entry_station, :exit_station, :journeys

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journeys = []
  end

  def in_journey?
    @entry_station == nil ? false : true
  end

  def touch_in(station)
    fail "Please top up" if @balance < MINIMUM_FARE
    @entry_station = station 
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @exit_station = station
    save_journey
    @entry_station = nil
  end

  def top_up(amount)
    fail "Limit exceeded #{BALANCE_LIMIT}" if @balance + amount > BALANCE_LIMIT
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  private
  def save_journey
    journey = {
      @entry_station => @exit_station
    }
    @journeys << journey
  end
end
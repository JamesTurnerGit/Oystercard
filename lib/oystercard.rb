class Oystercard
  attr_reader :balance, :start_station, :journey_history, :current_journey
  BALANCE_MAX = 90
  BALANCE_MIN = 1

  def initialize
    @balance = 0
    @journey_history = []
    @current_journey ||= Journey.new
  end

  def top_up money
    message = "balance threshold exceeded :£#{BALANCE_MAX}"
    raise message if (@balance + money) > BALANCE_MAX
    @balance += money
  end

  def deduct money
    @balance -= money
  end

  def touch_in station
    raise "balance too low for journey" if @balance < BALANCE_MIN
    @current_journey.start station
    # @start_station = station
  end

  def touch_out station
    @current_journey.end station
    @balance -= @current_journey.calculate_fare
    @journey_history << {start_station: start_station, end_station: station}
    # @start_station = nil
    # deduct BALANCE_MIN
  end

  def in_journey?
    !!@start_station
  end
end

#!/usr/bin/env ruby

require 'capybara'
require 'capybara/dsl'
require 'date'

# Use PhantomJS
require 'capybara/poltergeist'
Capybara.register_driver :poltergeist_custom do |app|
  Capybara::Poltergeist::Driver.new app,
                                    phantomjs_options: %w(--load-images=no --ignore-ssl-errors=yes)
end
Capybara.current_driver = :poltergeist_custom
Capybara.javascript_driver = :poltergeist_custom

# Use Firefox
# Capybara.current_driver = :selenium

Capybara.app_host = 'https://venta.renfe.com'
Capybara.run_server = false  # disable Rack server, we are accessing a remote web
Capybara.default_max_wait_time = 5

class Scraper
  include Capybara::DSL

  attr_accessor :first_day_without_trains

  def initialize
    raise 'No "key" file exsist. Put your IFTTT Maker channel key there' if not File.exists? 'key'
    @key = open('key', &:read)
  end

  def first_day_without_trains
    return @first_day_without_trains if not @first_day_without_trains.nil?
    if File.exists? 'first_day_without_trains'
      @first_day_without_trains = Date.parse(IO.read('first_day_without_trains'))
      return @first_day_without_trains
    else
      return Date.today
    end
  end

  def first_day_without_trains=(value)
    @first_day_without_trains = value
    IO.write('first_day_without_trains', value.to_s)
  end

  def scrap
    day = first_day_without_trains
    while trains_published? 'Barcelona', 'Madrid', day
      day += 1
    end
  end

  # Have trains been published for a given origin, destination and day
  def trains_published?(origin, destination, day=Date.today)
    visit '/'
    fill_hidden 'estacionOrigen_CdgoEstacion', '0071,BARCE,null'
    fill_hidden 'estacionDestino_CdgoEstacion', '0071,MADRI,null'
    fill_in 'SALIDA', with: day.strftime('%d/%m/%Y')
    click_on 'COMPRAR'
    page.assert_selector 'button[title="Comprar"]'

    puts "Trains found for #{day} from #{origin} to #{destination}"

    # Notify via IFTTT Maker Channel
    message = "New trains for #{day} from #{origin} to #{destination}"
    visit "https://maker.ifttt.com/trigger/notification/with/key/#{@key}?value1=#{message}"

    return true

  rescue Capybara::ExpectationNotMet
    puts "No trains found for #{day} from #{origin} to #{destination}"
    self.first_day_without_trains = day
    return false
  end

  protected

  def fill_hidden(id, value)
    find "input##{id}", visible: :hidden  # wait for input to be present
    page.execute_script "$('input##{id}').val('#{value}')"
  end

end

Scraper.new.scrap

#!/usr/bin/env ruby

require 'capybara'
require 'capybara/dsl'

# Configure poltergesit
# require 'capybara/poltergeist'
# Capybara.register_driver :poltergeist_custom do |app|
#   Capybara::Poltergeist::Driver.new(app, :timeout => 60)
# end
# Capybara.current_driver = :poltergeist
# Capybara.javascript_driver = :poltergeist

Capybara.app_host = 'https://venta.renfe.com'
Capybara.run_server = false  # disable Rack server, we are accessing a remote web
Capybara.current_driver = :selenium
Capybara.default_max_wait_time = 5

class Scraper
  include Capybara::DSL

  def scrap
    puts 'Main page...'
    visit '/'

    fill_hidden 'estacionOrigen_CdgoEstacion', '0071,BARCE,null'
    fill_in 'estacionOrigen_DescEstacion', with: 'BARCELONA (TODAS)'
    # find("ui-id-79").click

    fill_hidden 'estacionDestino_CdgoEstacion', '0071,MADRI,null'
    fill_in 'estacionDestino_DescEstacion', with: 'MADRID (TODAS)'

    fill_in 'SALIDA', with: '13/12/2015'

    click_on 'COMPRAR'

    sleep 5

    # curl "https://maker.ifttt.com/trigger/new_ave/with/key/#{KEY}?value1=BCNMAD&value2=Viernes"

  # rescue Exception => e
  #   puts e
  end

  protected

  def fill_hidden(id, value)
    page.execute_script "$('input##{id}').val('#{value}')"
  end

end

Scraper.new.scrap

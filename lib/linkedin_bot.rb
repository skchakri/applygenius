require 'selenium-webdriver'
require_relative 'utils'

class LinkedInBot
  def initialize
    @driver = Selenium::WebDriver.for :chrome, options: chrome_options
  end

  def chrome_options
    opts = Selenium::WebDriver::Chrome::Options.new
    opts.add_argument('--start-maximized')
    opts
  end

  def login
    @driver.navigate.to "https://www.linkedin.com/login"
    sleep 2
    @driver.find_element(:id, 'username').send_keys(ENV['LINKEDIN_EMAIL'])
    @driver.find_element(:id, 'password').send_keys(ENV['LINKEDIN_PASSWORD'])
    @driver.find_element(:css, 'button[type=submit]').click
    sleep 3
  end

  def search_jobs
    @driver.navigate.to "https://www.linkedin.com/jobs"
    sleep 2
    @driver.find_element(:css, 'input[aria-label="Search jobs"]').send_keys("Ruby on Rails")
    location_box = @driver.find_element(:css, 'input[aria-label="Search location"]')
    location_box.clear
    location_box.send_keys("United States")
    location_box.send_keys(:return)
    sleep 3
  end

  def each_easy_apply_job
    job_cards = @driver.find_elements(:css, '.job-card-container--clickable')
    job_cards.each_with_index do |card, index|
      card.click
      sleep 2

      title    = safe_text(:css, 'h2.topcard__title')
      company  = safe_text(:css, 'a.topcard__org-name-link')
      location = safe_text(:css, 'span.topcard__flavor--bullet')
      description = safe_text(:css, 'div.show-more-less-html__markup')

      job = {
        title: title,
        company: company,
        location: location,
        description: description
      }

      apply_btns = @driver.find_elements(:css, 'button.jobs-apply-button')
      next if apply_btns.empty?

      apply_btns.first.click
      sleep 2
      yield job
    end
  end

  def fill_form(letter)
    begin
      phone_inputs = @driver.find_elements(:css, 'input[aria-label*="Phone"]')
      phone_inputs.each { |input| input.clear; input.send_keys(ENV['PHONE_NUMBER']) }

      file_inputs = @driver.find_elements(:css, 'input[type="file"]')
      file_inputs[0].send_keys(File.expand_path('./resume.pdf'))
      file_inputs[1].send_keys(letter[:pdf]) if file_inputs.size > 1
    rescue => e
      puts "⚠️ Form fill issue: #{e.message}"
    end
  end

  def submit_if_simple
    if @driver.find_elements(:css, 'button[aria-label="Submit application"]').any?
      @driver.find_element(:css, 'button[aria-label="Submit application"]').click
      sleep 2
      return true
    else
      if @driver.find_elements(:css, 'button[aria-label="Dismiss"]').any?
        @driver.find_element(:css, 'button[aria-label="Dismiss"]').click
      end
      return false
    end
  end

  def shutdown
    @driver.quit
  end

  private

  def safe_text(type, selector)
    @driver.find_element(type, selector).text rescue "N/A"
  end
end

class EventUrlToImageJob < ApplicationJob
  queue_as :default

  def perform(event)
    url = event.url
    browser = Ferrum::Browser.new(process_timeout: 30, timeout: 200)
    browser.resize(width: 1200, height: 630)

    browser.goto(url)
    browser.network.wait_for_idle
    sleep 5

    # browser.screenshot(path: "app/assets/images/#{url.parameterize}.jpg", format: 'jpg', quality: 40)
    tempfile = Tempfile.new
    browser.screenshot(path: tempfile.path, format: 'jpg', quality: 40)
    event.image.attach(io: File.open(tempfile.path), filename: "#{event.url.parameterize}.jpg")

    EventOgImageJob.perform_later(event)
  ensure
    browser.quit
  end
end

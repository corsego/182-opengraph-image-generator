class EventUrlToImageJob < ApplicationJob
  queue_as :default

  def perform(event)
    url = event.url
    browser = Ferrum::Browser.new
    browser.resize(width: 1200, height: 630)
    browser.go_to(url)
    browser.network.wait_for_idle
    sleep 2
    # browser.screenshot(path: "app/assets/images/#{url.parameterize}.jpg", quality: 40, format: 'jpg')

    tmp = Tempfile.new
    browser.screenshot(path: tmp.path, quality: 40, format: 'jpg')
    event.image.attach(io: File.open(tmp.path), filename: "#{url.parameterize}.jpg")

    EventOgImageJob.perform_later(event)
  ensure
    browser.quit
  end
end

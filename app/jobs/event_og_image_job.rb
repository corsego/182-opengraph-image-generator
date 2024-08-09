class EventOgImageJob < ApplicationJob
  queue_as :default

  def perform(event)
    @event = event
    browser = Ferrum::Browser.new(process_timeout: 30, timeout: 200)
    browser.resize(width: 1200, height: 630)

    html = ApplicationController.render(
      template: "events/og",
      layout: "minimal",
      assigns: { event: event })

    frame = browser.frames.first
    frame.content = html
    browser.network.wait_for_idle

    # browser.screenshot(path: "app/assets/images/#{event.url.parameterize}.jpg", format: 'jpg', quality: 40)
    tempfile = Tempfile.new
    browser.screenshot(path: tempfile.path, format: 'jpg', quality: 40)
    event.og_image.attach(io: File.open(tempfile.path), filename: "og-#{event.url.parameterize}.jpg")

  ensure
    browser.quit
  end
end

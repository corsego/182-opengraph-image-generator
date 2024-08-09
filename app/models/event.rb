class Event < ApplicationRecord
  has_one_attached :image
  has_one_attached :og_image

  after_create_commit :enqueue_image_url_to_image_job

  def enqueue_image_url_to_image_job
    EventUrlToImageJob.perform_later(self)
  end
end

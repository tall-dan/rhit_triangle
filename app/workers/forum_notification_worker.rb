class ForumNotificationWorker
  include Sidekiq::Worker

  def perform(*forum_post_ids)
    forum_post_ids.each do |id|
      post = Forum::Post.find(id)
      post.tagged_members.each do |member|
        next if member.id == post.author_id
        # TODO: if we've edited a post, we'll come here. Need to see if the recipient already has an unacknowledged note
        Notification.create!(post_id: post.id, notifier_id: post.author_id, recipient_id: member.id)
      end
    end
  end
end
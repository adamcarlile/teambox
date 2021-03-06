module CommentsHelper

  def cache_editable_comment(comment, threaded, simpleconv, &block)
    cache(comment.cache_key.tap { |key|
      key << "-#{comment.user.avatar_updated_at.to_i}-#{comment.project.permalink}"
      key << '-editable' if can?(:edit, comment)
      key << '-destructable' if can?(:destroy, comment)
      key << '-threaded' if threaded
      key << '-simpleconv' if simpleconv
      key << ".#{request.format.to_sym}" if request.format.to_sym.to_s =~ /^\w+$/
    }, &block)
  end
  
  def activity_comment_user_link(comment)
    if comment.user.deleted_at
      "<span class='author' style='text-decoration: line-through'>#{comment.user.name}</span>"
    else
      content_tag :span,
        link_to(comment.user.name, user_path(comment.user)),
        :class => 'author'
    end
  end
  
  def activity_comment_target_link(comment, connector = "&rarr;")
    link = case comment.target_type
      when 'Conversation'
        link_to_conversation(comment.target.target)
      when 'Task'
        link_to_task(comment.target.target)
      when 'TaskList'
        link_to_task_list(comment.target.target)
    end
    "<span class='arr target_arr'>#{connector}</span> <span class='target'>#{link}</span>" if link
  end

  # TODO: phase out?
  def list_comments(comments, target)
    content_tag :div, render(comments), :class => 'comments', :id => 'comments'
  end

end
module OptimizeJBuilderPartialRendering
  def render_partial(event)
    # jbuilderの場合はログを書き出さない
    super unless event.payload[:identifier].end_with?(".jbuilder")
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::LogSubscriber.prepend(OptimizeJBuilderPartialRendering) if Rails.env.production?
end

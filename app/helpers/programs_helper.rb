module ProgramsHelper
  def program_row(program, title_ids, channel_ids, &block)
    classes = ['program', "title_#{program.title_id}"]
    if user_signed_in?
      classes << 'watchable' if channel_ids.include?(program.channel_id)
      classes << 'watching' if title_ids.include?(program.title_id)
    end
    content_tag(:tr, class: classes.join(' '), &block)
  end

  def anime_time_format(time)
    hour = time.hour
    hour += 24 if hour < 5
    time.strftime("#{hour}:%M")
  end
end

module ChatGptMdConverter
  module Helpers
    def remove_blockquote_escaping(output)
      output.gsub('&lt;blockquote&gt;', '<blockquote>')
            .gsub('&lt;/blockquote&gt;', '</blockquote>')
    end
  end
end

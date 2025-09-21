# ChatGptMdConverter

ChatGptMdConverter converts ChatGPT-flavoured Markdown into HTML that Telegram clients accept. It takes the Markdown you copy from ChatGPT (including nested emphasis, lists, code blocks, blockquotes, and inline links) and prepares a string you can send via the Telegram Bot API with `parse_mode: 'HTML'`.

## Features
- Converts Markdown emphasis to Telegram-safe `<b>`, `<i>`, `<u>`, and `<s>` tags, including mixed or nested styling
- Preserves inline code and fenced code blocks, adding language classes (e.g., `language-ruby`) when present
- Escapes `<`, `>`, and `&` outside of code blocks so Telegram renders text safely
- Normalises Markdown lists into Telegram bullets (`•`) and keeps ordered lists intact
- Wraps multi-line blockquotes in `<blockquote>` and removes ChatGPT citation artefacts
- Ensures unmatched backticks are closed before conversion to avoid malformed Telegram messages

## Installation

Add the gem to your project:

```bash
bundle add chat_gpt_md_converter
```

Or install it globally:

```bash
gem install chat_gpt_md_converter
```

## Usage

Require the formatter and pass in the Markdown you want to deliver to Telegram:

```ruby
require 'chat_gpt_md_converter'

markdown = <<~MD
  **Release plan**
  1. _Gather_ requirements
  2. Ship `code`

  ```ruby
  puts 'Hello from ChatGPT'
  ```

  > Reminder: link previews can be disabled.

  [Project board](https://github.com/phrippy/chat_gpt_md_converter)
MD

html = ChatGptMdConverter::TelegramFormatter.telegram_format(markdown)

# Example with the Telegram Bot API
bot.api.send_message(
  chat_id: chat_id,
  text: html,
  parse_mode: 'HTML',
  disable_web_page_preview: true
)
```

The example above renders on Telegram as:

```
<b>Release plan</b>
1. <i>Gather</i> requirements
2. Ship <code>code</code>

<pre><code class="language-ruby">puts 'Hello from ChatGPT'
</code></pre>

<blockquote>Reminder: link previews can be disabled.</blockquote>

<a href="https://github.com/phrippy/chat_gpt_md_converter">Project board</a>
```

### Tips
- ChatGPT footnote-style citations (`【n†source】`) are removed automatically; keep the raw links if you need them.
- Telegram only supports a subset of HTML. Always send the resulting string with `parse_mode: 'HTML'`.
- If you need custom behaviour, extend or monkey-patch the modules in `lib/` (e.g., `Converters`, `Formatters`).

## Development

- `bin/setup` installs dependencies.
- `bundle exec rspec` (or `rake spec`) runs the test suite.
- `bin/console` opens an interactive shell with the gem loaded.

When releasing:

```bash
bundle exec rake release
```

This updates the version, tags the release, and publishes the gem.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/phrippy/chat_gpt_md_converter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/phrippy/chat_gpt_md_converter/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ChatGptMdConverter project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/phrippy/chat_gpt_md_converter/blob/master/CODE_OF_CONDUCT.md).

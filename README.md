# lita-dm-notifier

[![Gem Version](https://badge.fury.io/rb/lita-dm-notifier.svg)](https://badge.fury.io/rb/lita-dm-notifier)
[![Build Status](https://travis-ci.org/mbainter/lita-dm-notifier.png?branch=master)](https://travis-ci.org/mbainter/lita-dm-notifier)
[![Coverage Status](https://coveralls.io/repos/mbainter/lita-dm-notifier/badge.svg?branch=master&service=github)](https://coveralls.io/github/mbainter/lita-dm-notifier?branch=master)



This is a simple handler to allow leveraging Lita to send direct messages to users via webhooks. Historically email is usually how we send out notifications from our systems, but with modern authentication systems and often dynamic ip addressing this can be a headache. With this handler you can instead send a simple post call to Lita and send rich messages to users for notifications instead.

Note: At the moment this *only* works with the Slack adaptor. 

## Installation

Add lita-dm-notifier to your Lita instance's Gemfile:

``` ruby
gem "lita-dm-notifier"
```

## Configuration

There is no configuration necessary for this plugin as of yet.

## Usage

Send a post call with a JSON blob to your Lita's HTTP endpoint, such as http://lita:8080/dm/notify/. At a minimum it needs the `text`, `fields`, `type` and `user` fields. Beyond that you can add any field from the [Slack attachment API](https://api.slack.com/docs/message-attachments) except color and it will honor it.

If the `type` field is set to "info", "good", "warning", or "danger" it will set the color accordingly using slack's options, otherwise the color will be "black". The type will also be included as a field added to whatever fields are passed in. If no `fallback` field is included then fallback will be set to the same content as the `text` field.

The `user` field should be the mention_name for the user in slack.

So, with a message of:
```json
{
    "fields": [],
    "footer": "http cli test of lita-dm-notifier",
    "text": "This is a test of lita-dm-notifier",
    "title": "THIS IS A TEST. THIS IS ONLY A TEST",
    "title_link": "http://github.com/mbainter/lita-dm-notifier",
    "type": "info",
    "user": "markb"
}
```

```
http --all --verbose POST http://localhost:8080/dm/notify @/tmp/dm-notifier-test.json
POST /dm/notify HTTP/1.1
...
HTTP/1.1 200 OK
Transfer-Encoding: chunked
```

![Example output in Slack](https://raw.github.com/mbainter/lita-dm-notifier/master/example.png)

# License

[Simplified BSD](https://opensource.org/licenses/BSD-2-Clause)

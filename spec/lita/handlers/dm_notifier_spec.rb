require 'spec_helper'

describe Lita::Handlers::DmNotifier, lita_handler: true do
  it { is_expected.to route_http(:post, '/dm/notify').to(:send_notification) }
  #
  # describe "#send_notification" do
  # end
end

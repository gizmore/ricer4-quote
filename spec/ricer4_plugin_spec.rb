require 'spec_helper'

describe Ricer4::Plugins::Quote do
  
  # LOAD
  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run

  USERS = Ricer4::User
  QUOTES = Ricer4::Plugins::Quote::Entity

  it("can flush tables") do
    USERS.destroy_all
    QUOTES.destroy_all
  end

  it("can add quotes and search them") do
    expect(bot.exec_line_as_for("Ugah", "Quote/Add", "This is a test")).to start_with("msg_added:{\"quote_id\":")
    expect(QUOTES.count).to eq(1)
    expect(bot.exec_line_as_for("Ugah", "Quote/List")).to start_with("msg_list_item_page:{\"classname\":\"Entity\",\"page\":1,\"pages\":1,\"items\":1,\"out\":\"")
    expect(bot.exec_line_as_for("Ugah", "Quote/Search", "a test")).to start_with('display_show_item:{"id":')
    
  end
  
  it("can abbonement new quotes") do
    expect(bot.exec_line_as_for("Ugah", "Quote/Announce", "on")).to start_with("msg_saved_setting:")
    expect(bot.exec_line_as_for("Gunda", "Quote/Add", "This is another test")).to start_with("msg_added:{\"quote_id\":")
  end
  
end

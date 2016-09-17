require_relative "spec_helper"
require_relative "../sinatra_graphql_erb.rb"

def app
  SinatraGraphqlErb
end

describe SinatraGraphqlErb do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end

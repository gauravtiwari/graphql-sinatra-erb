class SinatraGraphqlErb < Sinatra::Base
  set public_folder: 'public', static: true
  use Rack::Session::Cookie, secret: 'super_secret_client_key'
  use Rack::Protection
  use Rack::Protection::RemoteReferrer
  use Sass::Plugin::Rack

  private

  def query(definition, variables = {})
    response = API::Client.query(
      definition,
      variables: variables,
      context: client_context
    )

    case response
    when GraphQL::Client::SuccessfulResponse
      response.data
    when GraphQL::Client::FailedResponse
      raise response.errors
    end
  end

  def client_context
    { access_token: ENV['ACCESS_TOKEN'] }
  end

  get '/' do
    data = query IndexQuery
    erb :index, locals: {
      posts: data.root.posts
    }
  end


  get '/posts/:id' do
    data = query ShowQuery, id: params["id"]
    erb :show, locals: {
      post: data.node,
      comments: data.node.comments
    }
  end
end

IndexQuery = API::Client.parse <<-'GRAPHQL'
  query {
    root {
      id,
      tags,
      posts(first: 10) {
        edges {
          node {
            id,
            title,
            slug,
            excerpt,
            voted,
            user_id,
            created_at,
            comments_count,
            tags,
            votes_count,
            user {
              name,
            }
          }
        }
        pageInfo {
          hasNextPage
        }
      }
    }
  }
GRAPHQL

ShowQuery = API::Client.parse <<-'GRAPHQL'
  query($id: ID!) {
    node(id: $id) {
      id
      ... on Post {
        id,
        title,
        slug,
        body,
        voted,
        user_id,
        created_at,
        comments_count,
        tags,
        votes_count,
        user {
          name,
        }
        comments(first: 10, order: "-id") {
          edges {
            node {
              id,
              votes_count,
              voted,
              id,
              body,
              is_owner,
              votes_count,
              voted,
              created_at,
              user {
                name,
              },
            }
          },
          pageInfo {
            hasNextPage
          }
        }
      }
    }
  }
GRAPHQL

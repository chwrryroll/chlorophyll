import gleam/result .{try}
import gleam/dynamic/decode

import gleam/json
import gleam/httpc
import gleam/http
import gleam/http/request

import envoy as env

import utils/read

import app/error .{type ServiceError}

import pages/stats/struct .{type User}

pub fn user(by username: String) -> Result(User, ServiceError) {
  use query <- try(
    read.chars("/schemas/stats.gql")
    |> result.replace_error(error.SomethingWentWrong)
  )
  let assert Ok(body) = request.to("https://api.github.com/graphql")
  let assert Ok(token) = env.get("GITHUB_TOKEN")

  let req = body
  |> request.set_method(http.Post)
  |> request.prepend_header("Content-Type", "application/json")
  |> request.prepend_header("Authorization", "bearer " <> token)
  |> request.set_body(
    json.object([
      #("query", json.string(query)),
      #("variables", json.object([
        #("login", json.string(username)),
        #("startTime", json.string("2025-12-31T23:59:59Z")),
        // #("after", Will be implemented later... (I'm lazy"))
      ]))
    ])
    |> json.to_string
  )
  use res <- result.try(
    httpc.send(req)
    |> result.map_error(error.HttpRequestFailed)
  )
  use decode <- result.try(decode(res.body))
  Ok(decode)
}

fn decode(json_string: String) -> Result(User, ServiceError) {
  let decoder = {
    use username <- decode.subfield(
      ["data", "user", "name"],
      decode.string)
    use avatar_url <- decode.subfield(
      ["data", "user", "avatarUrl"],
      decode.string)
    use earned_stars <- decode.subfield(
      ["data", "user", "repositories", "nodes"],
      decode.list(
        decode.at(["stargazerCount"], decode.int)
      ))
    use commits <- decode.subfield(
      ["data", "user", "contributions", "totalCommitContributions"],
      decode.int)
    use pull_requests <- decode.subfield(
      ["data", "user", "pullRequests", "totalCount"],
      decode.int)
    use open_issues <- decode.subfield(
      ["data", "user", "openIssues", "totalCount"],
      decode.int)
    use closed_issues <- decode.subfield(
      ["data", "user", "closedIssues", "totalCount"],
      decode.int)
    use contributes <- decode.subfield(
      ["data", "user", "contributions", "totalRepositoryContributions"],
      decode.int)
    decode.success(struct.User(
      username, avatar_url, earned_stars, commits,
      pull_requests, closed_issues, open_issues, contributes
    ))
  }
  use data <- try(
    json.parse(from: json_string, using: decoder)
    |> result.map_error(error.ParsingFailed)
  )
  Ok(data)
}

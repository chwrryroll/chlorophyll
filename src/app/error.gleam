import gleam/httpc
import gleam/json

import wisp

import assets/lang

pub type ServiceError {
  // Query errors
  AssetDoesNotExist(String)
  LanguageIsNotSupported(String)

  // Critical Errors
  AssetCouldNotLoaded(String)
  TranslationFailed(lang.Locale)
  HttpRequestFailed(httpc.HttpError)
  ParsingFailed(json.DecodeError)
  SomethingWentWrong
}

pub fn report(message: String) {
  let svg = "
<svg xmlns=\"http://www.w3.org/2000/svg\">
  <defs>
    <style>
      div {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100%;
        background: black;
        font-family: sans-serif;
      }

      h1 {
        color: white;
        margin: 0;
      }

      h2 {
        color: gray;
        margin: 10px 0;
      }
    </style>
  </defs>
  <foreignObject width=\"1380\" height=\"550\">
    <div xmlns=\"http://www.w3.org/1999/xhtml\">
      <h1>Opps!</h1>
      <h2>" <> message <> "</h2>
    </div>
  </foreignObject>
</svg>
"
  wisp.ok()
  |> wisp.html_body(svg)
  |> wisp.set_header("content-type", "image/svg+xml")
  |> wisp.set_header("Cache-Control", "public, max-age=31536000")
}

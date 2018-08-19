json.partial! "api/words/index_base", locals: {words: @words}

json.token @random_fetched_token.token

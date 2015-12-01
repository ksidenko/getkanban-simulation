
import Card exposing (init, update, view)
import StartApp.Simple exposing (start)


main =
  start
    { model = init 2 3 2
    , update = update
    , view = view
    }

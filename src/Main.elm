import StartApp.Simple as StartApp

import Board exposing (init, update, view)


main =
  StartApp.start
    { model = Board.init 1 2 3 4 5
    , update = Board.update
    , view = Board.view
    }

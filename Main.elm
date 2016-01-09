import Task exposing (Task, andThen)
import TaskTutorial exposing (getCurrentTime, print)
import Task exposing (Task, andThen)
import Effects exposing (Never)
import Signal exposing (..)

import Card exposing (init, update, view)
import Column exposing (..)
import ColumnGroup exposing (..)
import Board exposing (..)

--https://github.com/evancz/start-app/blob/master/src/StartApp.elm
import StartApp

app =
  StartApp.start
    { init = Board.init 1 2 3 4 5
    , view = Board.view
    , update = Board.update
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks





-- some test with Tasks
printTimeVerbose : Task x ()
printTimeVerbose =
  getCurrentTime `andThen` \time -> print time

port runner : Task x ()
port runner = printTimeVerbose

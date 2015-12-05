
import Task exposing (Task, andThen)
import TaskTutorial exposing (getCurrentTime, print)
import Task exposing (Task, andThen)
import Debug exposing (..)

import Card exposing (init, update, view)
import Column exposing (..)
import ColumnGroup exposing (..)
--import Board exposing (..)
import StartApp.Simple exposing (start)

main =
  start
    { model = Column.init
    , update = Column.update
    , view = Column.view
    }

printTimeVerbose : Task x ()
printTimeVerbose =
    getCurrentTime `andThen` \time -> print time

port runner : Task x ()
port runner = printTimeVerbose

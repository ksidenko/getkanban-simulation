module Board where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Column exposing (Model, init, update, view)

-- MODEL

type alias Model =
    { selected : Column.Model
    , analytic: Column.Model
    , development: Column.Model
    , testing: Column.Model
    , deploy: Column.Model
    }


init : Int -> Int -> Int -> Int -> Int -> Model
init s a d t dd =
    { selected = Column.init "Selected" 2 a True
    , analytic = Column.init "Analytic" 3 a False
    , development = Column.init "Development" 2 d False
    , testing = Column.init "Testing" 2 t True
    , deploy = Column.init "Deploy" 100 dd False
    }

-- UPDATE

type Action
    = SelectedAddCard Column.Action
    | AnalyticAddCard Column.Action
    | DevelopmentAddCard Column.Action
    | TestingAddCard Column.Action
    | DeployAddCard Column.Action



update : Action -> Model -> Model
update action model =
  case action of
    SelectedAddCard act ->
      { model | selected = Column.update act model.selected
      }

    AnalyticAddCard act ->
      { model | analytic = Column.update act model.analytic
      }

    DevelopmentAddCard act ->
      { model | development = Column.update act model.development
      }

    TestingAddCard act ->
      { model | testing = Column.update act model.testing
      }

    DeployAddCard act ->
      { model | deploy = Column.update act model.deploy
      }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [] [ text "" ]
    , Column.view (Signal.forwardTo address SelectedAddCard) model.selected
    , Column.view (Signal.forwardTo address AnalyticAddCard) model.analytic
    , Column.view (Signal.forwardTo address DevelopmentAddCard) model.development
    , Column.view (Signal.forwardTo address TestingAddCard) model.testing
    , Column.view (Signal.forwardTo address DeployAddCard) model.deploy
    ]

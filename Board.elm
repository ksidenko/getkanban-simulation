module Board where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Column exposing (Model, init, update, view)
import ColumnGroup exposing (Model, init, update, view)

-- MODEL

type alias Model =
    { selected : ColumnGroup.Model
    , analytic: ColumnGroup.Model
    , development: ColumnGroup.Model
    , testing: ColumnGroup.Model
    , deploy: ColumnGroup.Model
    }


init : Int -> Int -> Int -> Int -> Int -> Model
init s a d t dd =
    { selected = ColumnGroup.init s "Selected" True
    , analytic = ColumnGroup.init a "Analytic" False
    , development = ColumnGroup.init d "Development" False
    , testing = ColumnGroup.init t "Testing" True
    , deploy = ColumnGroup.init dd "Deploy" False
    }

-- UPDATE

type Action
    = SelectedAddCard ColumnGroup.Action
    | AnalyticAddCard ColumnGroup.Action
    | DevelopmentAddCard ColumnGroup.Action
    | TestingAddCard ColumnGroup.Action
    | DeployAddCard ColumnGroup.Action



update : Action -> Model -> Model
update action model =
  case action of
    SelectedAddCard act ->
      { model | selected = ColumnGroup.update act model.selected
      }

    AnalyticAddCard act ->
      { model | analytic = ColumnGroup.update act model.analytic
      }

    DevelopmentAddCard act ->
      { model | development = ColumnGroup.update act model.development
      }

    TestingAddCard act ->
      { model | testing = ColumnGroup.update act model.testing
      }

    DeployAddCard act ->
      { model | deploy = ColumnGroup.update act model.deploy
      }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [] [ text "" ]
    , ColumnGroup.view (Signal.forwardTo address SelectedAddCard) model.selected
    , ColumnGroup.view (Signal.forwardTo address AnalyticAddCard) model.analytic
    , ColumnGroup.view (Signal.forwardTo address DevelopmentAddCard) model.development
    , ColumnGroup.view (Signal.forwardTo address TestingAddCard) model.testing
    , ColumnGroup.view (Signal.forwardTo address DeployAddCard) model.deploy
    ]

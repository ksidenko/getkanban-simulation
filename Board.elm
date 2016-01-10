module Board where

import Effects exposing (Effects, Never)
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


init : Int -> Int -> Int -> Int -> Int -> (Model, Effects Action)
init s a d t dd =
    let
      (selected, selectedFx) = ColumnGroup.init s "Selected" True
      (analytic, analyticFx) = ColumnGroup.init a "Analytic" False
      (development, developmentFx) = ColumnGroup.init d "Development" False
      (testing, testingFx) = ColumnGroup.init t "Testing" True
      (deploy, deployFx) = ColumnGroup.init dd "Deploy" False
    in
      ( Model selected analytic development testing deploy
      , Effects.batch
        [ Effects.map SelectedAddCard selectedFx
        , Effects.map AnalyticAddCard analyticFx
        , Effects.map DevelopmentAddCard developmentFx
        , Effects.map TestingAddCard testingFx
        , Effects.map DeployAddCard deployFx
        ]
      )


-- UPDATE

type Action
    = SelectedAddCard ColumnGroup.Action
    | AnalyticAddCard ColumnGroup.Action
    | DevelopmentAddCard ColumnGroup.Action
    | TestingAddCard ColumnGroup.Action
    | DeployAddCard ColumnGroup.Action



update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    SelectedAddCard act ->
      let
        (selected_, fx_) = ColumnGroup.update act model.selected
      in
        ( Model selected_ model.analytic model.development model.testing model.deploy 
        , Effects.map SelectedAddCard fx_
        )

    AnalyticAddCard act ->
      let
        (analytic_, fx_) = ColumnGroup.update act model.analytic
      in
        ( Model model.selected analytic_ model.development model.testing model.deploy 
        , Effects.map AnalyticAddCard fx_
        )

    DevelopmentAddCard act ->
      let
        (development_, fx_) = ColumnGroup.update act model.development
      in
        ( Model model.selected model.analytic development_ model.testing model.deploy 
        , Effects.map DevelopmentAddCard fx_
        )

    TestingAddCard act ->
      let
        (testing_, fx_) = ColumnGroup.update act model.testing
      in
        ( Model model.selected model.analytic model.development testing_ model.deploy 
        , Effects.map TestingAddCard fx_
        )

    DeployAddCard act ->
      let
        (deploy_, fx_) = ColumnGroup.update act model.deploy
      in
        ( Model model.selected model.analytic model.development model.testing deploy_
        , Effects.map DeployAddCard fx_
        )

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

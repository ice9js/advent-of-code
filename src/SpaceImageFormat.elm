module SpaceImageFormat exposing (..)

import Basics exposing (min)
import List exposing (drop, foldl, isEmpty, length, map, map2, repeat, sum, take)

type alias ImageData = List Int
type alias Layer = List Int

getLayers: Int -> ImageData -> List Layer
getLayers layerSize image =
    case length image >= layerSize of
        True -> [take layerSize image] ++ (getLayers layerSize (drop layerSize image))
        _ -> []

countDigits: Int -> Layer -> Int
countDigits n layer =
    sum (map (\d -> if d == n then 1 else 0) layer)

leastDigits: Int -> Layer -> Layer -> Layer
leastDigits n a b =
    case (isEmpty b, countDigits n a < countDigits n b) of
        (True, _) -> a
        (_, True) -> a
        _ -> b

reduceLayers: (Layer -> Layer -> Layer) -> Int -> Int -> ImageData -> Layer
reduceLayers reducer width height image =
    foldl reducer [] (getLayers (width * height) image)

paintPixel: Int -> Int -> String
paintPixel over under =
    case over of
        2 -> String.fromInt under
        0 -> " "
        _ -> String.fromInt over

paintImage: Int -> Int -> ImageData -> String


paintLine width over under =
    case (over, under) of
        (a::x, b::y) -> map2 
        _ -> repeat width 2

paintLine: width layer =


paintImage width height image =
    let
        imageSize =
            width * height
        layers =
            getLayers imageSize image
    in
    case layers of
        layer::rest -> map2 



stackPixels: Int -> Int -> Int
stackPixels over under =
    case over of
        2 -> under
        _ -> over

stackLayers: Int -> List Layer -> Layer
stackLayers imageSize layers =
    case layers of
        layer::rest -> map2 stackPixels layer (stackLayers imageSize rest)
        _ -> repeat imageSize 2

renderPixel: Int -> String
renderPixel p =
    case p of
        0 -> " "
        _ -> String.fromInt p

renderLines: Int -> Layer -> String
renderLines width layer =
    case layer of
        [] -> ""
        _ -> (String.concat (map renderPixel (take width layer)))
            ++ "|"
            ++ (renderLines width (drop width layer))

renderImage: Int -> Int -> ImageData -> String
renderImage width height image =
    let imageSize = width * height
    in
    getLayers imageSize image
        |> stackLayers imageSize
        |> renderLines width

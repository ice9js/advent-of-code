module SpaceImageFormat exposing (..)

import List exposing (drop, foldl, isEmpty, length, map, sum, take)

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

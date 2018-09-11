-- |
-- Module      : Main
-- Copyright   : (c) 2018 Harendra Kumar
--
-- License     : MIT
-- Maintainer  : harendra.kumar@gmail.com

{-# LANGUAGE TemplateHaskell #-}

module Main (main) where

import Benchmarks.BenchmarkTH (createBgroup)
import Benchmarks.Common (benchIO)
--import Benchmarks.BenchmarkTH (createScaling)

import qualified Benchmarks.Vector as Vector
import qualified Benchmarks.Streamly as Streamly
import qualified Benchmarks.Streaming as Streaming
import qualified Benchmarks.Machines as Machines
import qualified Benchmarks.Pipes as Pipes
import qualified Benchmarks.Conduit as Conduit
import qualified Benchmarks.Drinkery as Drinkery
import qualified Benchmarks.List as List
import qualified Benchmarks.VectorPure as VectorPure
import qualified Benchmarks.OrthPipes as OrthPipes
-- import qualified Benchmarks.LogicT as LogicT
-- import qualified Benchmarks.ListT as ListT
-- import qualified Benchmarks.ListTransformer as ListTransformer

import Gauge

main :: IO ()
main = do
  defaultMain
    [ bgroup "elimination"
      [ $(createBgroup "drain" "toNull")
      , $(createBgroup "toList" "toList")
      , $(createBgroup "fold" "foldl")
      , $(createBgroup "last" "last")
      ]
    , bgroup "transformation"
      [ $(createBgroup "scan" "scan")
      , $(createBgroup "map" "map")
      , $(createBgroup "mapM" "mapM")
      --, $(createBgroup "concat" "concat")
      ]
    , bgroup "filtering"
      [ $(createBgroup "filter-even" "filterEven")
      , $(createBgroup "filter-all-out" "filterAllOut")
      , $(createBgroup "filter-all-in" "filterAllIn")
      , $(createBgroup "take-all" "takeAll")
      , $(createBgroup "takeWhile-true" "takeWhileTrue")
      , $(createBgroup "drop-all" "dropAll")
      , $(createBgroup "dropWhile-true" "dropWhileTrue")
      ]
{-    , $(createBgroup "zip" "zip")
    , bgroup "append"
      [ benchIO "streamly" Streamly.appendSource Streamly.toNull
      , benchIO "conduit" Conduit.appendSource Conduit.toNull
--    , benchIO "pipes" Pipes.appendSource Pipes.toNull
      , bench "pipes" $ nfIO (return 1 :: IO Int)
--    , benchIO "vector" Vector.appendSource Vector.toNull
      , bench "vector" $ nfIO (return 1 :: IO Int)
--    , benchIO "streaming" Streaming.appendSource Streaming.toNull
      , bench "streaming" $ nfIO (return 1 :: IO Int)
      ]-}
      {-
      -- Perform 100,000 mapM recursively over a stream of length 10
      -- implemented only for vector and streamly.
      bgroup "mapM-nested"
    , [ benchIO "streamly" Streamly.mapMSource Streamly.toNull
      , benchIO "vector" Vector.mapMSource Vector.toNull
      ]
      -}
    , bgroup "compose"
      [ $(createBgroup "mapM" "composeMapM")
      , $(createBgroup "map-with-all-in-filter" "composeMapAllInFilter")
      , $(createBgroup "all-in-filters" "composeAllInFilters")
      , $(createBgroup "all-out-filters" "composeAllOutFilters")
      , $(createBgroup "drop-one" "composeDropOne")
      ]
    -- XXX Disabling this for now to reduce the running time
    -- We need a way to include/exclude this dynamically
    {-
    , bgroup "compose-scaling"
        -- Scaling with same operation in sequence
      [ $(createScaling "vector-filters" "Vector")
      , $(createScaling "streamly-filters" "Streamly")
      , $(createScaling "streaming-filters" "Streaming")
      , $(createScaling "machines-filters" "Machines")
      , $(createScaling "pipes-filters" "Pipes")
      , $(createScaling "conduit-filters" "Conduit")
      ]
      -}
   ]

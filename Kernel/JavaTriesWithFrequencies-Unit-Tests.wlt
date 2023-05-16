
(* :Title: JavaTriesWithFrequencies-Unit-Tests *)
(* :Author: Anton Antonov *)
(* :Date: 2017-01-19 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2017 Anton Antonov *)
(* :Keywords: prefix tree, trie, Java, Mathematica, Wolfram Language, unit test *)
(* :Discussion:

  In order to use this unit tests file set the correct paths in the test with ID "JavaTriePaths".

*)

(*PacletInstall["AntonAntonov`JavaTriesWithFrequencies`"];*)
Needs["AntonAntonov`JavaTriesWithFrequencies`"];

BeginTestSection["JavaTriesWithFrequencies-Unit-Tests"];

VerificationTest[(* 1 *)
    userDirName = $HomeDirectory;
    dirName = FileNameJoin[ { userDirName, "Downloads"} ];
    $JavaTriesWithFrequenciesPath = FileNameJoin[{dirName, "Java-TriesWithFrequencies.jar"}];
    {
      DirectoryQ[dirName],
      FileExistsQ[$JavaTriesWithFrequenciesPath],
      Length[PacletFind["AntonAntonov/JavaTriesWithFrequencies"]] > 0
    }
  ,
  {True, True, True}
  ,
  TestID -> "JavaTriePaths"
];


VerificationTest[(* 2 *)
  AppendTo[$Path, dirName];
  JavaTrieInstall[$JavaTriesWithFrequenciesPath]
  ,
  Null
  ,
  TestID -> "JavaTrieInitialization"
];

VerificationTest[(* 3 *)
  CompoundExpression[
    Set[words, List["bark", "barkeeper", "barkeepers", "barkeep", "barks", "barking", "barked", "barker", "barkers"]],
    Set[jTr, JavaTrieCreateBySplit[words]],
    StringMatchQ[SymbolName[jTr], StringExpression["JavaObject", BlankSequence[]]]
  ]
  ,
  True
  ,
  TestID -> "JavaTrieCreation1"
];

VerificationTest[(* 4 *)
  CompoundExpression[
    Set[words2, List["bar", "barring", "car", "care", "caress", "cold", "colder"]],
    Set[jTr2, JavaTrieCreateBySplit[words2]],
    StringMatchQ[SymbolName[jTr2], StringExpression["JavaObject", BlankSequence[]]]
  ]
  ,
  True
  ,
  TestID -> "JavaTrieCreation2"
];

VerificationTest[(* 5 *)
  CompoundExpression[
    Set[jTr1, JavaTrieCreate[Map[Characters, words]]],
    StringMatchQ[SymbolName[jTr1], StringExpression["JavaObject", BlankSequence[]]]
  ]
  ,
  True
];

VerificationTest[(* 6 *)
  res = JavaTrieToJSON[ JavaTrieShrink[jTr] ];
  MatchQ[ res, <|"key" -> "", "value" -> 9., "children" -> ___|> ]
  ,
  True
  ,
  TestID -> "JavaTrieToJSON"
];

VerificationTest[(* 7 *)
  JavaTrieHasCompleteMatchQ[jTr, Characters[#]] & /@ {"bark", "ba"}
  ,
  {True, False}
  ,
  TestID -> "JavaTrieHasCompleteMatchQ"
];

VerificationTest[(* 8 *)
  Cases[
		JavaTrieToJSON[ JavaTrieShrink[jTr] ] //. Association[x__] :> List[x] ,
		RuleDelayed[Rule["key", Pattern[v, Blank[]]], v], Infinity]
  ,
  List["", "bark", "s", "ing", "e", "r", "s", "d", "ep", "er", "s"]
  ,
  TestID -> "JavaTrieShrink1"
];

VerificationTest[(* 9 *)
  Cases[
		JavaTrieToJSON[JavaTrieShrink[jTr, "~"]] //. Association[x__] :> List[x],
		RuleDelayed[Rule["key", Pattern[v, Blank[]]], v], Infinity]
  ,
  List["", "b~a~r~k", "i~n~g", "s", "e", "r", "s", "d", "e~p", "e~r", "s"]
  ,
  TestID -> "JavaTrieShrink2"
];

VerificationTest[(* 10 *)
  JLink`JavaObjectToExpression[JavaTrieContainsQ[jTr, Map[Characters, List["barked", "balm", "barking"]]]]
  ,
  List[True, False, True]
  ,
  TestID -> "JavaTrieContains1"
];

VerificationTest[(* 11 *)
  JLink`JavaObjectToExpression[JavaTrieHasCompleteMatchQ[jTr, Map[Characters, List["barked", "balm", "barking"]]]]
  ,
  List[True, False, True]
];

VerificationTest[(* 12 *)
  Apply[StringJoin, JavaTrieGetWords[jTr2, List["b"]], List[1]]
  ,
  List["bar", "barring"]
  ,
  TestID -> "JavaTrieGetWords1"
];

VerificationTest[(* 13 *)
  Apply[StringJoin, JavaTrieGetWords[jTr2, List["c"]], List[1]]
  ,
  List["car", "care", "caress", "cold", "colder"]
  ,
  TestID -> "JavaTrieGetWords2"
];

VerificationTest[(* 14 *)
  CompoundExpression[Set[jTr3, JavaTrieMerge[jTr, jTr2]], Union[Apply[StringJoin, JavaTrieGetWords[jTr3, List["b"]], List[1]], Apply[StringJoin, JavaTrieGetWords[jTr3, List["c"]], List[1]]]]
  ,
  Union[words, words2]
  ,
  TestID -> "JavaTrieGetWords3"
];

VerificationTest[(* 15 *)
  JavaTrieRootToLeafPaths[jTr]
  ,
  List[List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["s", 1.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["e", 6.`], List["r", 2.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["e", 6.`], List["r", 2.`], List["s", 1.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["e", 6.`], List["d", 1.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["e", 6.`], List["e", 3.`], List["p", 3.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["e", 6.`], List["e", 3.`], List["p", 3.`], List["e", 2.`], List["r", 2.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["e", 6.`], List["e", 3.`], List["p", 3.`], List["e", 2.`], List["r", 2.`], List["s", 1.`]], List[List["", 9.`], List["b", 9.`], List["a", 9.`], List["r", 9.`], List["k", 9.`], List["i", 1.`], List["n", 1.`], List["g", 1.`]]]
  ,
  TestID -> "JavaRootToLeafPaths1"
];

VerificationTest[(* 16 *)
  JavaTrieGetWords[JavaTrieShrink[jTr], List["bark"]]
  ,
  List[List["bark"], List["bark", "s"], List["bark", "ing"], List["bark", "e", "r"], List["bark", "e", "r", "s"], List["bark", "e", "d"], List["bark", "e", "ep"], List["bark", "e", "ep", "er"], List["bark", "e", "ep", "er", "s"]]
  ,
  TestID -> "JavaTrieShrinkAndGetWords1"
];

VerificationTest[(* 17 *)
  CompoundExpression[
    Set[jTr, JavaTrieCreateBySplit[words]],
    Set[jTr1, JavaTrieCreate[Map[Characters, words]]],
    JavaTrieEqualQ[jTr, jTr1]
  ]
  ,
  True
  ,
  TestID -> "JavaTrieEqual1"
];

VerificationTest[(* 18 *)
  (JavaTrieToJSON@JavaTrieShrink@jTr) == (JavaTrieToJSON@JavaTrieShrink@JavaTrieClone@jTr)
  ,
  True
  ,
  TestID -> "JavaTrieCloneEquality1"
];

VerificationTest[(* 19 *)
  JavaTrieHasCompleteMatchQ[jTr2, Characters@#] & /@ {"ba", "bar"}
  ,
  {False, True}
  ,
  TestID -> "JavaTrieHasCompleteMatchQ1"
];

VerificationTest[(* 20 *)
  JavaTrieGetWords[jTr, {"b", "a", "r", "k"}] ==
      JavaTrieGetWords[JavaTrieNodeProbabilities[jTr], {"b", "a", "r", "k"}]
  ,
  True
  ,
  TestID -> "JavaTrieGetWords1"
];

VerificationTest[(* 21 *)
  (JavaTrieRootToLeafPaths[
    JavaTrieRetrieve[jTr, {"b", "a", "r", "k"}]] /. x_?NumberQ :> 0) ==
      (JavaTrieRootToLeafPaths[
        JavaTrieRetrieve[JavaTrieNodeProbabilities[jTr], {"b", "a", "r", "k"}]] /. x_?NumberQ :> 0)
  ,
  True
  ,
  TestID -> "JavaTrieRootToLeafPaths1"
];

VerificationTest[(* 22 *)
  Cases[JavaTrieToJSON[JavaTrieShrink[jTr]], RuleDelayed[Rule["key", Pattern[v, Blank[]]], v], Infinity] ==
      Cases[JavaTrieToJSON[JavaTrieShrink[JavaTrieNodeProbabilities[jTr]]], RuleDelayed[Rule["key", Pattern[v, Blank[]]], v], Infinity]
  ,
  True
  ,
  TestID -> "JavaTrieShrink2"
];

EndTestSection[]

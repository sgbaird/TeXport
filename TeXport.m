(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
Notation`AutoLoadNotationPalette=False;
BeginPackage["TeXport`","Notation`"];
Notation`AutoLoadNotationPalette=True;
Unprotect@@Names["TeXport`*"];
(*Unprotect[Evaluate[Context[]<>"*"]];*)
ClearAll@@Names["TeXport`*"];


(* ::Input::Initialization:: *)
Off[General::spell1];
Off[Symbolize::boxSymbolExists];(*subscripted symbols*)
Symbolize[ParsedBoxWrapper[SubscriptBox["_", "_"]]]
On[Symbolize::boxSymbolExists];


(* ::Input::Initialization:: *)
KeyToSubjectPredicate::usage="KeyToSubjectPredicate[keys] takes a set of keys (e.g. {a,b,c}) and outputs a predicate of these keys (e.g. \"where $a$, $b$, and $c$ represent \")";

ValueToObject::usage="ValueToObject[values] converts a set of values (e.g. {\"apples\",\"bananas\",\"cantaloupe\"} into the object of a sentence (e.g. \"apples, bananas, and cantaloupe, respectively.\")";

KeyValueToSentence::usage="KeyValueToSentence[keys,values] concatenates KeyToSubjectPredicate[keys] with ValueToObject[values] as in \"where $a$, $b$, and $c$ represent apples, bananas, and cantaloupe, respectively.\"";

TeXport::usage=
"TeXport[fname,eqn,keyvalues,Print\[Rule]True] prints a TeX-formatted expression to $Output with key-value pair definitions.
TeXport[fname,eqn,,Print\[Rule]True] prints a TeX-formatted expression to $Output without key-value pairs.
TeXport[fname,eqn,keyvalues,Export\[Rule]True] exports a TeX-formatted expression to <fname>.tex.
TeXport[fname,eqn,keyvalues,Export\[Rule]True,Folder\[Rule]\"equations\"] exports a TeX-formatted expression to equations\\<fname>.tex. To set default options for later calls to TeXport, use e.g. SetOptions[TeXport,Export\[Rule]True]
TeXport[fname,eqn,keyvalues] returns a TeX-formatted sentence corresponding to an expression (eqn) and a definition of variables (keyvalues) that immediately follows in a sentence format.";

OpenWriteTeX::usage="OpenWriteTeX[file] opens file such that writing to it will have an infinite page width and the UTF8 character encoding. This is especially useful for exporting full derivations (i.e. multiple expressions) and intermediate sentences to a .tex file. By default, file is overwritten when OpenWriteTeX is called.
OpenWriteTeX[] opens a temporary file with the same properties as above.
OpenWriteTeX[file,overwriteQ\[Rule]False] opens a file without overwriting (i.e. append to file).";

WL::usage="WL stands for and is a wrapper to WriteLine (MMA built-in function), but is shorter and easier to call. A default file can be set by using file=OpenWriteTeX@fpath and then SetOptions[WL,File\[Rule]file]. After setting a default file, WL@x and x//WL allow for less-obtrusive exporting code (i.e. generally more readable).
WL[x,File\[Rule]file] writes x to file.
WL[x,File\[Rule]file,Print\[Rule]True] writes x to file and prints to $Output.
WL[x] writes x to the default file specified by SetOptions[WL,File\[Rule]file].";

MathText::usage="MathText[x] converts the non-string expression x to a TeX version ($x$).";


(* ::Input::Initialization:: *)
Begin["`Private`"];


(* ::Input::Initialization:: *)
MakeBoxes[Det[x_],StandardForm]:=MakeBoxes@BracketingBar[x]
BracketingBar=Det;
NumericOrSymbol=(_?NumericQ|_Symbol);


(* ::Input::Initialization:: *)
KeyToSubjectPredicate[keys_]:="where "<>Switch[Length@keys,
0,"",
1,"$"<>ToString@TeXForm@keys[[1]]<>"$" <>" represents ",
2,"$"<>ToString@TeXForm@keys[[1]]<>"$"<>" and "<>"$"<>ToString@TeXForm@keys[[2]]<>"$"<>" represent ",
_Integer,StringRiffle["$"<>#<>"$"&/@ToString/@TeXForm/@keys[[;;-2]], ", "]<>", and "<>"$"<>ToString@TeXForm@keys[[-1]]<>"$"<>" represent "
];


(* ::Input::Initialization:: *)
ValueToObject[values_]:=Switch[Length@values,
0,"",
1,values[[1]]<>".",
2,values[[1]]<>" and "<>values[[2]]<>", respectively.",
_Integer,StringRiffle[values[[;;-2]], ", "]<>", and "<>values[[-1]]<>", respectively."
]


(* ::Input::Initialization:: *)
KeyValueToSentence[keys_,values_]:=KeyToSubjectPredicate[keys]<>ValueToObject[values]


(* ::Input::Initialization:: *)
Clear[TeXport]
Options[TeXport]={Print->False,Export->False,Folder->"."};
TeXport[fname_,eqn_,keyvalues_,OptionsPattern[]]:=Module[{folder,printQ,exportQ,fnametxt,fnametex,fpathtxt,fpathtex,txt,keys,values},

(*PARSE options*)
{printQ,exportQ,folder}=OptionValue[{"Print","Export","Folder"}];

(*MAKE file path strings*)
fnametxt=fname<>".txt";
fnametex=fname<>".tex";
{fpathtxt,fpathtex}=FileNameJoin[{folder,#}]&/@{fnametxt,fnametex};

(*MAKE the sentence*)
sentence=If[Length@keyvalues>0,{keys,values}=keyvalues;"
"<>KeyValueToSentence[keys,values],""];
txt="\\begin{equation} \\label{eq:"<>fname<>"}
	"<>ToString@TeXForm[eqn]<>"
\\end{equation}"<>sentence;

(*PRINT or EXPORT the result*)
If[exportQ,
Export[fpathtxt,txt];RenameFile[fpathtxt,fpathtex,OverwriteTarget->True],
##&[]];
If[printQ,
Print@txt,
##&[]];
txt
]


(* ::Input::Initialization:: *)
Clear[OpenWriteTeX]
OpenWriteTeX[file_:Missing[],overwriteQ_:True]:=Module[{},
If[overwriteQ,
If[Streams@(file/.Missing[]->"")!={},Close@file,##&[];If[FileExistsQ@file,DeleteFile@file,##&[]];],
##&[]
];
If[MissingQ[file],OpenWrite[PageWidth->Infinity,CharacterEncoding-> "UTF8"],OpenWrite[file,PageWidth->Infinity,CharacterEncoding-> "UTF8"]]
]


(* ::Input::Initialization:: *)
Clear[WL]
Options[WL]={"File"->"",Print->False};
WL[x_,OptionsPattern[]]:=Module[{file,printQ,fileOut},
file=OptionValue["File"];
printQ=OptionValue["Print"];
fileOut=If[Head@file===String,File@file,file];
WriteLine[fileOut,x];
If[printQ,WriteLine[$Output[[1]],x]];
fileOut
]


(* ::Input::Initialization:: *)
MathText[x_]:="$"<>ToString@TeXForm@x<>"$"


(* ::Input::Initialization:: *)
End[];
On[General::spell1];
Protect@@Names["TeXport`*"];
(*Protect[Evaluate[Context[]<>"*"]];*)
EndPackage[];




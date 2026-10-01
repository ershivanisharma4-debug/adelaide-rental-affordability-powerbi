let
  Source = Folder.Files("D:\Adelaide Rent Project"),
  #"Filtered hidden files" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
  #"Added custom" = let
    rootPath = Text.TrimEnd(Value.Metadata(Value.Type(#"Filtered hidden files"))[FileSystemTable.RootPath]?, "\"),
    combinePaths = (path1, path2) => Text.Combine({Text.TrimEnd(path1, "\"), path2}, "\"),
    getRelativePath = (path, relativeTo) => Text.Middle(path, Text.Length(relativeTo) + 1)
in
    Table.AddColumn(#"Filtered hidden files", "Relative Path", each getRelativePath(combinePaths([Folder Path], [Name]), rootPath), type text),
  #"Invoke custom function" = Table.AddColumn(#"Added custom", "Transform file", each #"Transform file"([Content])),
  #"Renamed columns" = Table.RenameColumns(#"Invoke custom function", {{"Relative Path", "Source.Name"}}),
  #"Removed other columns" = Table.SelectColumns(#"Renamed columns", {"Source.Name", "Transform file"}),
  #"Expanded table column" = Table.ExpandTableColumn(#"Removed other columns", "Transform file", Table.ColumnNames(#"Transform file"(#"Sample file"))),
  #"Changed column type" = Table.TransformColumnTypes(#"Expanded table column", {{"Column1", type text}, {"Column8", type text}}),
  #"Renamed columns 1" = Table.RenameColumns(#"Changed column type", {{"Column1", "Suburb"}, {"Column2", "Flat_1_count"}, {"Column3", "Flat_1_median"}, {"Column4", "Flat_2_count"}, {"Column5", "Flat_2_median"}, {"Column6", "Flat_3_count"}, {"Column7", "Flat_3_median"}, {"Column8", "Flat_4+_count"}, {"Column9", "Flat_4+_median"}}),
  #"Removed columns" = Table.RemoveColumns(#"Renamed columns 1", {"Column10", "Column11", "Column12", "Column13"}),
  #"Renamed columns 2" = Table.RenameColumns(#"Removed columns", {{"Column14", "House_1_count"}, {"Column15", "House_1_median"}, {"Column16", "House_2_count"}, {"Column17", "House_2_median"}, {"Column18", "House_3_count"}, {"Column19", "House_3_median"}, {"Column20", "House_4+_count"}, {"Column21", "House_4+_median"}}),
  #"Removed columns 1" = Table.RemoveColumns(#"Renamed columns 2", {"Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31"}),
  #"Removed top rows" = Table.Skip(#"Removed columns 1", 10),
  #"Removed top rows 1" = Table.Skip(#"Removed top rows", 6),
  #"Removed top rows 2" = Table.Skip(#"Removed top rows 1", 1),
  #"Unpivoted columns" = Table.UnpivotOtherColumns(#"Removed top rows 2", {"Source.Name", "Suburb"}, "Attribute", "Value"),
  #"Reordered columns" = Table.ReorderColumns(#"Unpivoted columns", {"Source.Name", "Attribute", "Value", "Suburb"}),
  #"Replaced value" = Table.ReplaceValue(#"Reordered columns", "*", null, Replacer.ReplaceValue, {"Value"}),
  #"Split column by delimiter" = Table.SplitColumn(#"Replaced value", "Attribute", Splitter.SplitTextByDelimiter("_"), {"Attribute.1", "Attribute.2", "Attribute.3"}),
  #"Renamed columns 3" = Table.RenameColumns(#"Split column by delimiter", {{"Attribute.1", "Dwelling Type"}, {"Attribute.2", "Bedrooms"}}),
  #"Added custom 1" = Table.TransformColumnTypes(Table.AddColumn(#"Renamed columns 3", "Quater Date", each Date.EndOfMonth(
    Date.FromText( Text.Start( Text.End([Source.Name], 12), 7 ) & "-01" )
)), {{"Quater Date", type date}}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Added custom 1", {{"Value", type number}}),
  #"Renamed columns 4" = Table.RenameColumns(#"Changed column type 1", {{"Quater Date", "Quarter Date"}, {"Attribute.3", "Measure"}}),
  #"Filtered rows" = Table.SelectRows(#"Renamed columns 4", each [Suburb] <> null and [Suburb] <> "Country Total" and [Suburb] <> "Grand Total" and [Suburb] <> "Metro Total" and [Suburb] <> "Row Labels"),
  #"Removed duplicates" = Table.Distinct(#"Filtered rows", {"Dwelling Type", "Bedrooms", "Measure", "Suburb", "Quarter Date"}),
  #"Pivoted column" = Table.Pivot(Table.TransformColumnTypes(#"Removed duplicates", {{"Measure", type text}}), List.Distinct(Table.TransformColumnTypes(#"Removed duplicates", {{"Measure", type text}})[Measure]), "Measure", "Value"),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Pivoted column", {{"count", Int64.Type}}),
  #"Renamed columns 5" = Table.RenameColumns(#"Changed column type 2", {{"count", "Count"}, {"median", "Median Rent"}})
in
  #"Renamed columns 5"

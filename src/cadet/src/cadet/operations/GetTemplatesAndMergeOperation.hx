  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.operations;

import cadet.operations.UndoableCompoundOperation;
import cadet.core.IComponent;import cadet.operations.GetTemplateAndMergeOperation;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.operations.IAsynchronousOperation;import core.app.core.operations.IUndoableOperation;import core.app.operations.UndoableCompoundOperation;class GetTemplatesAndMergeOperation extends UndoableCompoundOperation implements IAsynchronousOperation implements IUndoableOperation
{private var components : Array<Dynamic>;private var fileSystemProvider : IFileSystemProvider;private var domTable : Dynamic;public function new(components : Array<Dynamic>, fileSystemProvider : IFileSystemProvider, domTable : Dynamic = null)
    {
        super();this.components = components;this.fileSystemProvider = fileSystemProvider;this.domTable = domTable;if (domTable == null)             domTable = { };for (i in 0...components.length){var component : IComponent = components[i];if (component.templateID == null)                 {i++;continue;
            };var operation : GetTemplateAndMergeOperation = new GetTemplateAndMergeOperation(component.templateID, component, fileSystemProvider, domTable);addOperation(operation);
        }
    }override private function get_Label() : String{return "Get Templates And Merge";
    }
}
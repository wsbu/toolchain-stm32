#!/bin/bash

/opt/SystemWorkbench/eclipse \
    --launcher.suppressErrors \
    -nosplash \
    -no-indexer \
    -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
    "$@"

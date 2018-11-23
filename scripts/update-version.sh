#!/usr/bin/env bash
sed "s/VERSION_REPLACED_BY_CI/${CIRCLE_TAG}/g" THRichTextView.podspec > THRichTextView.podspec.tmp
cat THRichTextView.podspec.tmp
mv THRichTextView.podspec.tmp THRichTextView.podspec

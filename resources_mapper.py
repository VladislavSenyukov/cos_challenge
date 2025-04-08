import json
import os
import pathlib

def buildClass(className, classFields, fileContent):
    fileContent = fileContent + '\nclass ' + className + ' {\n'
    for field in classFields:
        fileContent = fileContent + field + '\n'
    fileContent = fileContent + '}'
    return fileContent

def buildClassFields(filenames, directory, shouldConvertToCamelCase, shouldReplaceNonAlphaNumeric = False):
    classFields = []
    for filename in sorted(filenames):
        itemName = pathlib.Path(filename).stem
        if shouldConvertToCamelCase == True:
            itemName = convertToCamelCase(itemName)
        elif shouldReplaceNonAlphaNumeric == True:
            itemName = convertAllNonAlphanumericsToUnderscores(itemName)
        classFields.append('  static const ' + itemName + " = '" + directory + filename + "';")
    return classFields

def convertToCamelCase(name: str):
    output = ''.join(character for character in name.title() if character.isalnum())
    return output[0].lower() + output[1:]

def convertAllNonAlphanumericsToUnderscores(name):
    return ''.join(character if character.isalnum() else '_' for character in name)

def writeToFile(filePath, content):
    with open(filePath, "w") as f:
        f.write(content)

svgFilter = lambda path: fileExtensionFilter(path, ['svg'])

def fileExtensionFilter(path, extensions):
    for imageExtension in extensions:
        if '.' + imageExtension in path:
            return True
    return False

# Build image_keys file
svgDirectory = 'assets/svg/'
svgFilenames = list(filter(svgFilter, os.listdir('./' + svgDirectory)))
imageKeysFileContent = buildClass('SvgKey', buildClassFields(svgFilenames, svgDirectory, True), '')
writeToFile('lib/utils/image_keys.dart', imageKeysFileContent)

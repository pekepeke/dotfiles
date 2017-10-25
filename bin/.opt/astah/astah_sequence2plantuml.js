//  This script convert Astah SequenceDiagram to plantuml fomat text
//  Author:      Chen Zhi
//  E-mail:      cz_666@qq.com
//  License: APACHE V2.0 (see license file)
 
var ISequenceDiagram = Java.type('com.change_vision.jude.api.inf.model.ISequenceDiagram');
var ILifeline = Java.type('com.change_vision.jude.api.inf.model.ILifeline');
var IMessage = Java.type('com.change_vision.jude.api.inf.model.IMessage');
var HashMap = Java.type('java.util.HashMap');
 
run();
 
function run() {
 
    var diagramViewManager = astah.getViewManager().getDiagramViewManager();
    var diagram = diagramViewManager.getCurrentDiagram();
 
    if (!(diagram instanceof ISequenceDiagram)) {
        print('Open a ISequenceDiagram and run again.');
        return;
    }
 
    var presentations = diagram.getPresentations();
    var lifelinePresentations = getLifelinePresentations(presentations);
    var lifelineNames = getLifelineNames(lifelinePresentations);
    var messagePresentations = getMassagePresentations(presentations);
 
    print('@startuml');
    printLifeline(lifelinePresentations, lifelineNames);
    printMessages(messagePresentations, lifelineNames);
    print('@enduml');
 
}
 
function getLifelinePresentations(presentations) {
    var lifelinePresentations = new Array();
    for (var i in presentations) {
        var presentation = presentations[i];
        if (presentation.getModel() instanceof ILifeline) {
            lifelinePresentations[i] = presentation;
        }
    }
 
    lifelinePresentations.sort(orderOfLifelinePosition);
    return lifelinePresentations;
}
 
function orderOfLifelinePosition(a, b) {
    return a.getLocation().getX() - b.getLocation().getX();
}
 
function getLifelineNames(lifelinePresentations) {
    var lifelineNames = new HashMap();
    for (var i in lifelinePresentations) {
        var lifelineP = lifelinePresentations[i];
        if (lifelineP == undefined) {
            continue;
        }
        var lifeline = lifelineP.getModel();
        if (lifeline.getBase() != null) {
            lifelineNames.put(lifeline, lifeline.getName() + "_" + lifeline.getBase().getName());
        } else {
            lifelineNames.put(lifeline, lifeline.getName());
        }
    }
    return lifelineNames;
}
 
function printLifeline(lifelinePresentations, lifelineNames) {
    for (var i in lifelinePresentations) {
        var lifelineP = lifelinePresentations[i];
        if (lifelineP == undefined) {
            continue;
        }
        var lifeline = lifelineP.getModel();
        print("participant " + lifelineNames.get(lifeline));
    }
}
 
function getMassagePresentations(presentations) {
    var messagePresentations = new Array();
    for (var i in presentations) {
        var presentation = presentations[i];
        if (presentation.getModel() instanceof IMessage) {
            messagePresentations[i] = presentation;
        }
    }
 
    messagePresentations.sort(orderOfMessagePosition);
    return messagePresentations;
}
 
function orderOfMessagePosition(a, b) {
    return a.getPoints()[0].getY() - b.getPoints()[0].getY();
}
 
function printMessages(messagePresentations, lifelineNames) {
    for (var i in messagePresentations) {
        var messageP = messagePresentations[i];
        if (messageP == undefined) {
            continue;
        }
 
        var message = messageP.getModel();
        var sourceName = lifelineNames.get(message.getSource());
        var targetName = lifelineNames.get(message.getTarget());
 
        print(sourceName + getArrow(message) + targetName + ':' + getText(message));
 
    }
}
 
function getArrow(message) {
    if (message.isReturnMessage()) {
        return " -->> ";
    }
    if (message.isAsynchronous()) {
        return " ->> ";
    }
    return " -> ";
}
 
function getText(message) {
    var index = message.getIndex();
    if (message.isReturnMessage()) {
        index = "reply";
    }
    var messageName = message.getName();
    if (messageName == null) {
        messageName = "";
    }
    return index + '.' + messageName;
}
//  This script convert Astah SequenceDiagram to mermaid fomat text
//  Author:      Chen Zhi
//  E-mail:      cz_666@qq.com
//  License: APACHE V2.0 (see license file)
 
var ISequenceDiagram = Java.type('com.change_vision.jude.api.inf.model.ISequenceDiagram');
var ArrayList = Java.type('java.util.ArrayList');
var Arrays = Java.type('java.util.Arrays');
var Comparator = Java.type('java.util.Comparator');
var Collections = Java.type('java.util.Collections');
var HashMap = Java.type('java.util.HashMap');
 
var INDENT = '    ';
 
run();
 
function run() {
 
    var diagramViewManager = astah.getViewManager().getDiagramViewManager();
    var diagram = diagramViewManager.getCurrentDiagram();
 
 
    if (!(diagram instanceof ISequenceDiagram)) {
        print('Open a ISequenceDiagram and run again.');
        return;
    }
 
    print(diagram + ' Sequence');
    print('```mermaid');
    print('sequenceDiagram;');
 
    var lifelinePresentations = getLifelinePresentations(diagram);
    var lifelineNames = getLifelineNames(lifelinePresentations);
    printLifelines(lifelinePresentations, lifelineNames);
 
    var messagePresentations = getMessagePresentations(diagram);
    printMessages(messagePresentations, lifelineNames);
 
    print('```');
 
}
 
function getLifelinePresentations(diagram) {
 
    var presentations = diagram.getPresentations();
 
    var interaction = diagram.getInteraction();
    var lifelines = interaction.getLifelines();
 
    var lifelinePresentations = new ArrayList();
    for (var i in presentations) {
        var presentation = presentations[i];
        if (Arrays.asList(lifelines).contains(presentation.getModel())) {
            lifelinePresentations.add(presentation);
        }
    }
 
    Collections.sort(lifelinePresentations, new Comparator() {
        compare: function ( a, b ) {
            return a.getLocation().getX() - b.getLocation().getX();
        }
    });
 
    return lifelinePresentations;
 
}
 
function getLifelineNames(lifelinePresentations) {
 
    var lifelineNames = new HashMap();
    for (var i in lifelinePresentations) {
        var lifeline = lifelinePresentations[i].getModel();
        if (lifeline.getBase() != null) {
            lifelineNames.put(lifeline, lifeline.getName() + '_' + lifeline.getBase());
        } else {
            lifelineNames.put(lifeline, lifeline.getName());
        }
    }
 
    return lifelineNames;
 
}
 
function printLifelines(lifelinePresentations, lifelineNames) {
 
    for (var i in lifelinePresentations) {
        var lifeline = lifelinePresentations[i].getModel();
        print(INDENT + 'participant ' + lifelineNames.get(lifeline) + ';');
    }
 
}
 
function getMessagePresentations(diagram) {
 
    var interaction = diagram.getInteraction();
    var msgs = interaction.getMessages();
    var messagePresentations = new ArrayList();
    var presentations = diagram.getPresentations();
    for (var i in presentations) {
        var presentation = presentations[i];
        if (Arrays.asList(msgs).contains(presentation.getModel())) {
            messagePresentations.add(presentation);
        }
    }
 
    Collections.sort(messagePresentations, new Comparator() {
        compare: function ( a, b ) {
            return a.getPoints()[0].getY() - b.getPoints()[0].getY();
        }
    });
 
    return messagePresentations;
 
}
 
function printMessages(messagePresentations, lifelineNames) {
 
    for (var i in messagePresentations) {
 
        var presentation = messagePresentations[i];
        var model = presentation.getModel();
        var source = model.getSource();
        var target = model.getTarget();
 
        print(INDENT + lifelineNames.get(source) + getArrowString(model)
                + lifelineNames.get(target) + ':' + getIndexString(model) + '.' + model.getName());
 
    }
 
}
 
function getIndexString(model) {
 
    if (model.isReturnMessage()) {
        return 'reply';
    }
 
    return model.getIndex();
 
}
 
function getArrowString(model) {
 
    if (model.isReturnMessage()) {
        return '-->>';
    }
 
    if (model.isAsynchronous()) {
        return '-x';
    }
 
    return '->>';
 
}
//  This script convert Astah flowchart to mermaid fomat text 
//  Author:      Chen Zhi
//  E-mail:      cz_666@qq.com
//  License: APACHE V2.0 (see license file) 
 
 
var IActivityDiagram = Java.type('com.change_vision.jude.api.inf.model.IActivityDiagram');
var IControlNode = Java.type('com.change_vision.jude.api.inf.model.IControlNode');
var HashMap = Java.type('java.util.HashMap');
 
var ID_PREFIX = 'A';
var REPLACEMENT_CHAR = '?';
var INDENT = '    ';
 
run();
 
function run() {
 
    var diagramViewManager = astah.getViewManager().getDiagramViewManager();
    var diagram = diagramViewManager.getCurrentDiagram();
    if (!(diagram instanceof IActivityDiagram)) {
        print('Open a flowchart and run again.');
        return;
    }
 
    if (!(diagram.isFlowChart())) {
        print('Open a flowchart and run again.');
        return;
    }
 
    var activity = diagram.getActivity();
    var activityNodes = activity.getActivityNodes();
    var activityNodeIds = getActivityNodeIds(activityNodes);
    var flows = activity.getFlows();
 
    print(diagram + ' Flowchart');
    print('```mermaid');
    print('graph TB');
    printObjectDefine(activityNodes, activityNodeIds);
    printFlowchartLogic(flows, activityNodeIds);
    print('```');
 
}
 
function getActivityNodeIds(activityNodes) {
    var activityNodeIds = new HashMap();
    for (var i in activityNodes) {
        var nodeId = ID_PREFIX + i;
        var node = activityNodes[i];
        activityNodeIds.put(node, nodeId);
    }
    return activityNodeIds;
}
 
function printObjectDefine(activityNodes, activityNodeIds) {
    for (var i in activityNodes) {
        var node = activityNodes[i];
        var nodeId = activityNodeIds.get(node);
        if (isRhombus(node)) {
            print(INDENT + nodeId + '{' + replaceUnavailableCharacters(node.getName()) + '}');
            continue;
        }
        if (isRectangle(node)) {
            print(INDENT + nodeId + '[' + replaceUnavailableCharacters(node.getName()) + ']');
            continue;
        }
        print(INDENT + nodeId + '(' + replaceUnavailableCharacters(node.getName()) + ')');
    }
}
 
function replaceUnavailableCharacters(string) {
 
    var newString = string.replace(/\n/g, ' ');
 
    newString = newString.replace(/\(/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\)/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\[/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\]/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\{/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\}/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\;/g, REPLACEMENT_CHAR);
    newString = newString.replace(/\|/g, REPLACEMENT_CHAR);
    newString = newString.replace(/E/g, REPLACEMENT_CHAR);
 
    return newString;
}
 
function printFlowchartLogic(flows, activityNodeIds) {
 
    for (var i in flows) {
        var flow = flows[i];
        var sourceId = activityNodeIds.get(flow.getSource());
        if (sourceId == null) {
            continue;
        }
        var targetId = activityNodeIds.get(flow.getTarget());
        if (targetId == null) {
            continue;
        }
        if (flow.getGuard() != "") {
            print(INDENT + sourceId + "-->|" + replaceUnavailableCharacters(flow.getGuard()) + "| " + targetId);
            continue;
        }
        print(INDENT + sourceId + "-->" + targetId);
    }
}
 
function isRhombus(node) {
    if (node instanceof IControlNode && node.isDecisionMergeNode()) {
        return true;
    }
    var stereotypes = node.getStereotypes();
    return stereotypes.length > 0 && 'judgement'.equals(stereotypes[0]);
}
 
function isRectangle(node) {
    var stereotypes = node.getStereotypes();
    return stereotypes.length > 0 && 'flow_process'.equals(stereotypes[0]);
}
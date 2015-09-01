$mongoServer = "mongodb://user:password@localhost:27017";
$mongoOptions = array("connect" => true);
$mongoDriverOptions = array();
$mongo = new MongoClient($mongoServer, $mongoOptions, $mongoDriverOptions);

$testDb = $mongo->test;
$collection = $testDb->collection;
$cursor = $collection->find();
foreach ($cursor as $doc) {
    var_dump($doc);
    break;
}

$mongo->close();

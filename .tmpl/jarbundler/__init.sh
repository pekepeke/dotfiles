#!/bin/bash

APP_NAME="$(basename $(dirname $0))"
main() {
  [ ! -e lib ] && mkdir lib

  # http://docs.oracle.com/javase/7/docs/technotes/guides/jweb/packagingAppsForMac.html
  # https://java.net/downloads/appbundler/appbundler.html
  # https://bitbucket.org/infinitekind/appbundler/downloads
  # http://informagen.com/JarBundler/dist/jarbundler.zip

  [ ! -e lib/appbundler-1.0.jar ] && curl -o lib/appbundler-1.0.jar -L https://java.net/projects/appbundler/downloads/download/appbundler-1.0.jar
  [ ! -e dist ] && mkdir dist
  # manifest
  JAR_FILENAME=$(find . -type f -name '*.jar' | grep -v appbundler-1.0.jar | grep -v "dist/"| head -1)
  MAIN_CLASS=$(show_jar_manifest "$JAR_FILENAME" | grep -e '^Main-Class' | awk '{print $2}' | tr -d '\r' | tr -d '\n')
  IDENTIFIER=$(show_jar_manifest "$JAR_FILENAME" | grep -v "org.eclipse.jdt.internal" | grep -e '^\(Rsrc-\)\?Main-Class' | head -1 | awk '{print $2}' | tr -d '\r' | tr -d '\n')
  # CLASSPATH=$(show_jar_manifest "$JAR_FILENAME" | grep -e '^Main-Class' | awk '{print $2}')

  [ ! -e Makefile ] && makefile > Makefile

  if [ -e build.xml ]; then
    build-xml
  else
    build-xml > build.xml
  fi

}

makefile() {
  echo "APP_NAME=$APP_NAME"
  cat <<'EOM'

sign:
	codesign -s "Developer ID Application: CommonNameFromCertificate" ${APP_NAME}.app
	codesign -d --verbose=4 \${APP_NAME}.app
	spctl --assess --verbose=4 --type execute \${APP_NAME}.app

EOM
}
build-xml() {
cat <<EOM
<?xml version="1.0" encoding="UTF-8"?>
<project name="$APP_NAME" default="default" basedir=".">
	<!-- <import file="nbproject/build-impl.xml"/> -->
	<!-- <property environment="env" /> -->
	<taskdef name="bundleapp"
		classname="com.oracle.appbundler.AppBundlerTask"
		classpath="lib/appbundler-1.0.jar" />

	<target name="bundle">
		<bundleapp outputdirectory="dist"
			name="$APP_NAME"
			displayname="$APP_NAME"
			identifier="$IDENTIFIER"
			mainclassname="$MAIN_CLASS">
			<!-- icon="" -->
			<!-- <runtime dir="\${env.JAVA_HOME}" /> -->
			<classpath file="$JAR_FILENAME" />
		</bundleapp>
	</target>

</project>
EOM
}

show_jar_manifest() {
  unzip -p "$1" META-INF/MANIFEST.MF
}

main "$@"

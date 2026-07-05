allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    tasks.configureEach {
        if (this.javaClass.name.contains("KotlinCompile")) {
            try {
                val kotlinOptions = this.javaClass.getMethod("getKotlinOptions").invoke(this)
                kotlinOptions.javaClass.getMethod("setJvmTarget", String::class.java).invoke(kotlinOptions, "11")
            } catch (e: Exception) {}
        }
    }
    
    afterEvaluate {
        val androidExt = project.extensions.findByName("android")
        if (androidExt != null) {
            try {
                val compileOptions = androidExt.javaClass.getMethod("getCompileOptions").invoke(androidExt)
                val javaVersionClass = javaClass.classLoader.loadClass("org.gradle.api.JavaVersion")
                val version11 = javaVersionClass.getField("VERSION_11").get(null)
                compileOptions.javaClass.getMethod("setSourceCompatibility", javaVersionClass).invoke(compileOptions, version11)
                compileOptions.javaClass.getMethod("setTargetCompatibility", javaVersionClass).invoke(compileOptions, version11)
            } catch (e: Exception) {}

            val namespaceMethod = androidExt.javaClass.methods.find { it.name == "getNamespace" }
            if (namespaceMethod != null) {
                val currentNamespace = namespaceMethod.invoke(androidExt)
                if (currentNamespace == null) {
                    val setNamespaceMethod = androidExt.javaClass.methods.find { it.name == "setNamespace" }
                    if (setNamespaceMethod != null) {
                        setNamespaceMethod.invoke(androidExt, "com.example." + project.name.replace("-", "_"))
                    }
                }
            }
            // Strip package attribute from AndroidManifest.xml to satisfy AGP 8+ requirements
            val manifestFile = project.file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                var content = manifestFile.readText()
                if (content.contains("package=")) {
                    content = content.replace(Regex("""package="[^"]*""""), "")
                    manifestFile.writeText(content)
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

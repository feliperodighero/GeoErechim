buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Versão do Gradle Plugin Android
        classpath("com.android.tools.build:gradle:8.1.0")
        // Força a versão do Kotlin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.20")
    }
}

// Repositórios para todos os projetos
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
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

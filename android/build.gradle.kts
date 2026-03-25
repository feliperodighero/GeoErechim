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

// Repositórios e configurações para todos os projetos
allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Força a versão do androidx.core para 1.13.1 para evitar erro de compatibilidade com o AGP 8.9+
    configurations.all {
        resolutionStrategy {
            eachDependency {
                if (requested.group == "androidx.core" && (requested.name == "core" || requested.name == "core-ktx")) {
                    useVersion("1.13.1")
                }
            }
        }
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

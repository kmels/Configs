import org.ensime.Imports._

EnsimeKeys.compilerArgs in Compile := (scalacOptions in Compile).value ++ Seq("-Ywarn-dead-code", "-Ywarn-shadowing")

// custom settings (this is an example of adding scalariform formatting preferences):
EnsimeKeys.additionalSExp in Compile := (additionalSExp in Compile) := ":custom-key custom-value"


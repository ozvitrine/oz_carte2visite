package fr.oz_vitrine.ozcarte2visite

import android.app.Activity
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "oz_carte2visite/external_backup_folder"
    private val chooseFolderRequestCode = 4872
    private val preferencesName = "oz_carte2visite_settings"
    private val folderUriKey = "external_backup_folder_uri"

    private var pendingFolderResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "chooseFolder" -> chooseFolder(result)
                "getSelectedFolderName" -> result.success(getFolderName())
                "hasSelectedFolder" -> result.success(getFolderUri() != null)
                "writeWeeklyBackup" -> writeWeeklyBackup(call.arguments, result)
                "doesFileExist" -> doesFileExist(call.arguments, result)
                "keepOnlyLatestSeven" -> keepOnlyLatestSeven(result)
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "oz_carte2visite/app_locale",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAppLocale" -> {
                    val languageCode = call.argument<String>("languageCode")

                    if (languageCode == null) {
                        result.error(
                            "INVALID_ARGUMENT",
                            "languageCode manquant",
                            null,
                        )
                    } else {
                        AppCompatDelegate.setApplicationLocales(
                            LocaleListCompat.forLanguageTags(languageCode),
                        )
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun chooseFolder(result: MethodChannel.Result) {
        if (pendingFolderResult != null) {
            result.error(
                "FOLDER_PICKER_ALREADY_OPEN",
                "Le sélecteur de dossier est déjà ouvert.",
                null,
            )
            return
        }

        pendingFolderResult = result

        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                    Intent.FLAG_GRANT_PREFIX_URI_PERMISSION,
            )
        }

        startActivityForResult(intent, chooseFolderRequestCode)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode != chooseFolderRequestCode) return

        val result = pendingFolderResult
        pendingFolderResult = null

        if (result == null) return

        if (resultCode != Activity.RESULT_OK) {
            result.success(null)
            return
        }

        val uri = data?.data

        if (uri == null) {
            result.success(null)
            return
        }

        val flags = data.flags and (
            Intent.FLAG_GRANT_READ_URI_PERMISSION or
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )

        try {
            contentResolver.takePersistableUriPermission(uri, flags)

            preferences()
                .edit()
                .putString(folderUriKey, uri.toString())
                .apply()

            result.success(getFolderName())
        } catch (error: SecurityException) {
            result.error(
                "FOLDER_PERMISSION_FAILED",
                "Android n’a pas accordé l’autorisation permanente pour ce dossier.",
                error.message,
            )
        }
    }

    private fun writeWeeklyBackup(
        arguments: Any?,
        result: MethodChannel.Result,
    ) {
        val values = arguments as? Map<*, *>
        val fileName = values?.get("fileName") as? String
        val bytes = bytesFromMethodChannel(values?.get("bytes"))

        if (fileName.isNullOrBlank() || bytes == null) {
            result.error(
                "INVALID_BACKUP",
                "Les données de sauvegarde sont invalides.",
                null,
            )
            return
        }

        val folder = selectedFolderOrError(result) ?: return

        try {
            folder.findFile(fileName)?.delete()

            val backupFile = folder.createFile(
                "application/octet-stream",
                fileName,
            )

            if (backupFile == null) {
                result.error(
                    "FILE_CREATION_FAILED",
                    "Impossible de créer le fichier de sauvegarde.",
                    null,
                )
                return
            }

            val outputStream: OutputStream? =
                contentResolver.openOutputStream(backupFile.uri)

            if (outputStream == null) {
                result.error(
                    "FILE_WRITE_FAILED",
                    "Impossible d’écrire la sauvegarde.",
                    null,
                )
                return
            }

            outputStream.use { stream ->
                stream.write(bytes)
                stream.flush()
            }

            // Vérifie physiquement que le fichier existe après son écriture.
            val writtenFile = folder.findFile(fileName)

            if (writtenFile == null || !writtenFile.isFile) {
                result.error(
                    "FILE_NOT_FOUND_AFTER_WRITE",
                    "Le fichier n’est pas visible dans le dossier après son écriture.",
                    null,
                )
                return
            }

            result.success(
                mapOf(
                    "fileName" to (writtenFile.name ?: fileName),
                    "size" to writtenFile.length(),
                    "folderName" to (folder.name ?: ""),
                ),
            )
        } catch (error: Exception) {
            result.error(
                "BACKUP_WRITE_FAILED",
                error.message ?: "Erreur d’écriture de la sauvegarde.",
                null,
            )
        }
    }

    private fun doesFileExist(
        arguments: Any?,
        result: MethodChannel.Result,
    ) {
        val values = arguments as? Map<*, *>
        val fileName = values?.get("fileName") as? String

        if (fileName.isNullOrBlank()) {
            result.error(
                "INVALID_FILE_NAME",
                "Le nom du fichier est invalide.",
                null,
            )
            return
        }

        val folder = selectedFolderOrError(result) ?: return
        val file = folder.findFile(fileName)

        result.success(
            mapOf(
                "exists" to (file?.isFile == true),
                "fileName" to (file?.name ?: fileName),
                "size" to (file?.length() ?: 0L),
                "folderName" to (folder.name ?: ""),
            ),
        )
    }

    private fun selectedFolderOrError(
        result: MethodChannel.Result,
    ): DocumentFile? {
        val folderUri = getFolderUri()

        if (folderUri == null) {
            result.error(
                "NO_FOLDER_SELECTED",
                "Aucun dossier de sauvegarde n’a été sélectionné.",
                null,
            )
            return null
        }

        val folder = DocumentFile.fromTreeUri(this, folderUri)

        if (folder == null || !folder.canWrite()) {
            result.error(
                "FOLDER_NOT_WRITABLE",
                "Le dossier de sauvegarde n’est plus accessible ou autorisé en écriture.",
                null,
            )
            return null
        }

        return folder
    }

    private fun bytesFromMethodChannel(value: Any?): ByteArray? {
        if (value is ByteArray) return value
        if (value !is List<*>) return null

        return try {
            value.map { item ->
                when (item) {
                    is Int -> item.toByte()
                    is Number -> item.toByte()
                    else -> throw IllegalArgumentException()
                }
            }.toByteArray()
        } catch (_: IllegalArgumentException) {
            null
        }
    }

    private fun keepOnlyLatestSeven(result: MethodChannel.Result) {
        val folder = selectedFolderOrError(result) ?: return

        try {
            val backupFiles = folder.listFiles()
                .filter { file ->
                    file.isFile &&
                        file.name?.startsWith("oz_carte2visite_auto_") == true &&
                        file.name?.endsWith(".ozbackup") == true
                }
                .sortedByDescending { file -> file.name ?: "" }

            backupFiles
                .drop(7)
                .forEach { file -> file.delete() }

            result.success(backupFiles.take(7).size)
        } catch (error: Exception) {
            result.error(
                "BACKUP_CLEANUP_FAILED",
                error.message ?: "Erreur lors du nettoyage des sauvegardes.",
                null,
            )
        }
    }

    private fun getFolderUri(): Uri? {
        val uriValue = preferences().getString(folderUriKey, null)

        if (uriValue.isNullOrBlank()) return null

        return Uri.parse(uriValue)
    }

    private fun getFolderName(): String? {
        val folderUri = getFolderUri() ?: return null
        return DocumentFile.fromTreeUri(this, folderUri)?.name
    }

    private fun preferences(): SharedPreferences {
        return getSharedPreferences(preferencesName, MODE_PRIVATE)
    }
}
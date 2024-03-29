;;; rclone-tools.el --- Use Rclone in Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Thomas Freeman

;; Author: Thomas Freeman
;; Keywords: lisp
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file provides a number of functions to make it easy to use rclone from
;; within Emacs.

;;; Code:


(defgroup rclone-tools nil
  "Customization options for the rclone-tools package")

(defcustom rclone-config-file nil
  "The locaton of the rclone configuration file."
  :type '(string)
  :group 'rclone-tools)

(defcustom rclone-show-progress t
  "Whether to show progress when running rclone commands."
  :type '(boolean)
  :group 'rclone-tools)

(defcustom rclone-path (executable-find "rclone")
  "The location of the rclone exectable file."
  :type '(string)
  :group 'rclone-tools)

(defvar rclone-commands '(bisync copy sync)
  "A list of rclone commands available for use.")

(defvar rclone-remotes
  (split-string
   (shell-command-to-string "rclone listremotes"))
  "A list of all the available rclone remote storage systems")

(defun rclone-get-remote ()
  "Select a remote for rclone."
  (interactive)
  (completing-read "Select remote: "
                   rclone-remotes))

(defun rclone-get-command ()
  "Get the rclone command for the current operation"
  (completing-read "Rclone command: "
                   rclone-commands))

(defun rclone-get-remote ()
  "Select a remote for rclone."
  (completing-read "Select remote: "
                   rclone-remotes))

(defun rclone-get-local-directory ()
  (read-file-name "Local directory: "))

(defun rclone-config-option ()
  "Return an option telling rclone where to find the config file."
  (if (bound-and-true-p rclone-config-file)
      (format "--config %s" rclone-config-file)
    (format "")))



;;;###autoload

(defun rclone-run-remote-to-local (&optional command local-directory remote)
  "Run an rclone command interactively."
  (interactive)
  (let ((command (or command (rclone-get-command)))
        (local-directory (or local-directory (rclone-get-local-directory)))
        (remote (or remote (rclone-get-remote))))
    (eshell-command
     (format "%s %s -vP %s %s %s"
             rclone-path
             (rclone-config-option)
             command
             remote
             local-directory))))

(defun rclone-run-local-to-remote (&optional command local-directory remote)
  "Run an rclone command interactively."
  (interactive)
  (let ((command (or command (rclone-get-command)))
        (local-directory (or local-directory (rclone-get-local-directory)))
        (remote (or remote (rclone-get-remote))))
    (eshell-command
     (format "%s %s -vP %s %s %s"
             rclone-path
             (rclone-config-option)
             command
             local-directory
             remote))))

(provide 'rclone-tools)

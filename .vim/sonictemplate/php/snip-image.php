<?php

class Image {

	var $filename;
	var $imageWidth;
	var $imageHeight;
	var $width;
	var $height;
	var $ext;
	var $types = array('','gif','jpeg','png','swf');
	var $quality = 80;
	var $top = 0;
	var $left = 0;
	var $crop = false;
	var $type;

	function Image($name='') {
		$this->filename = $name;
		// $info = getimagesize($name);
		list($w, $h, $type, $attr) = getimagesize($name);
		// $this->imageWidth = $info[0];
		// $this->imageHeight = $info[1];
		// $this->type = $this->types[$info[2]];

		$this->imageWidth = $w;
		$this->imageHeight = $h;
		$this->type = $this->types[$type];

		$info = pathinfo($name);
		$this->dir = $info['dirname'];
		// $this->name = str_replace('.'.$info['extension'], '', $info['basename']);
		$this->name = str_replace('.'.$info['extension'], '', $info['basename']);
		$this->ext = $info['extension'];
	}

	function dir($dir = '') {
		if(!$dir) return $this->dir;
		$this->dir = $dir;
		return $this;
	}

	function name($name = '') {
		if(!$name) return $this->name;
		$this->name = $name;
		return $this;
	}

	function width($width = '') {
		$this->width = $width;
		return $this;
	}

	function height($height = '') {
		$this->height = $height;
		return $this;
	}

	function isSmallerOrEqualSize($w, $h) {
		// 指定された width, height よりも小さい画像であれば true を返却します。
		// true を返却するのは、width, height の両者とも小さい場合のみ
		return $w >= $this->imageWidth && $h >= $this->imageHeight;
	}

	function isBiggerOrEqualSize($w, $h) {
		// 指定された width, height よりも大きい画像であれば、true を返却します。
		// true を返却するのは、width, height の両者とも大きい場合のみ
		return $w <= $this->imageWidth && $h <= $this->imageHeight;
	}


	function aspectSize($maxWidth, $maxHeight, $is_bigger = true) {
		$w_ratio = $maxWidth / $this->imageWidth;
		$h_ratio = $maxHeight / $this->imageHeight;

		if ($is_bigger) {
			$use_width = $w_ratio > $h_ratio;
		} else {
			$use_width = $w_ratio < $h_ratio;
		}
		if ($use_width) {
			$this->aspectSizeByWidth($maxWidth);
		} else {
			$this->aspectSizeByHeight($maxHeight);
		}

		return $this;
	}

	function aspectSizeByWidth($width) {
		$this->width($width)
			->height(round($width / ($this->imageWidth / $this->imageHeight)));
		return $this;
	}

	function aspectSizeByHeight($height) {
		$this->height($height)
			->width(round($height / ($this->imageHeight / $this->imageWidth)));
		return $this;
	}

	function resize($percentage = 50) {
		if($this->crop) {
			$this->crop = false;
			$this->width = round($this->width*($percentage/100));
			$this->height = round($this->height*($percentage/100));
			$this->imageWidth = round($this->width/($percentage/100));
			$this->imageHeight = round($this->height/($percentage/100));
		} else {
			$this->width = round($this->imageWidth*($percentage/100));
			$this->height = round($this->imageHeight*($percentage/100));
		}
		return $this;

	}

	function crop($top = 0, $left = 0) {
		$this->crop = true;
		$this->top = $top;
		$this->left = $left;
		return $this;
	}

	function quality($quality = 80) {
		$this->quality = $quality;
		return $this;
	}

	function show() {
		$this->save(true);
	}

	function save($show = false) {

		if ($show) {
			@header('Content-Type: image/'.$this->type);
		}

		if (!$this->width && !$this->height) {
			$this->width = $this->imageWidth;
			$this->height = $this->imageHeight;
		} elseif (is_numeric($this->width) && empty($this->height)) {
			$this->aspectSizeByWidth($this->width);
		} elseif (is_numeric($this->height) && empty($this->width)) {
			$this->aspectSizeByHeight($this->height);
		} else {
			if ($this->width <= $this->height) {
				$height = round($this->width/($this->imageWidth/$this->imageHeight));
				if($height!=$this->height) {
					$percentage = ($this->imageHeight*100)/$height;
					$this->imageHeight = round($this->height*($percentage/100));
				}
			} else {
				$width = round($this->height/($this->imageHeight/$this->imageWidth));
				if($width!=$this->width) {
					$percentage = ($this->imageWidth*100)/$width;
					$this->imageWidth = round($this->width*($percentage/100));
				}
			}
		}

		if($this->crop) {
			$this->imageWidth = $this->width;
			$this->imageHeight = $this->height;
		}
		$create_fn = "imagecreatefrom".$this->type;
		$image_fn = "image" . $this->type;

		$image = $create_fn($this->filename);

		$new_image = imagecreatetruecolor($this->width, $this->height);
		imagecopyresampled($new_image, $image, 0, 0, $this->top, $this->left, $this->width, $this->height, $this->imageWidth, $this->imageHeight);

		// fix lotation by exif data
		if ($this->type == "jpeg") {
			$exif = exif_read_data($this->filename);
			if(!empty($exif['Orientation'])) {
				switch($exif['Orientation']) {
				case 8:
					$new_image = imagerotate($new_image,90,0);
					break;
				case 3:
					$new_image = imagerotate($new_image, 180,0);
					break;
				case 6:
					$new_image = imagerotate($new_image, -90,0);
					break;
				}
			}
		}

		$name = $show ? null: $this->dir.DIRECTORY_SEPARATOR.$this->name.'.'.$this->ext;
		// $name = $show ? null: $this->dir.DIRECTORY_SEPARATOR.$this->name;

		if ($this->type == 'jpeg') {
			imagejpeg($new_image, $name, $this->quality);
		} else {
			$image_fn($new_image, $name);
		}

		imagedestroy($image);
		imagedestroy($new_image);
	}

}



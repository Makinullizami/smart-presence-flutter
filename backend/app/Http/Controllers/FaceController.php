<?php

namespace App\Http\Controllers;

use App\Models\Face;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class FaceController extends Controller
{
    public function uploadEmbedding(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            'embedding' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        // Store the image
        $imagePath = $request->file('image')->store('faces', 'public');

        // Create face record
        $face = Face::create([
            'user_id' => $request->user_id,
            'image_path' => $imagePath,
            'embedding' => $request->embedding,
        ]);

        return response()->json([
            'message' => 'Face data uploaded successfully',
            'face' => $face,
        ], 200);
    }

    public function getUserFaces(Request $request, $userId)
    {
        $faces = Face::where('user_id', $userId)->get();

        return response()->json($faces);
    }

    public function recognizeFace(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'embedding' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $inputEmbedding = $request->embedding;

        // Simple face recognition - find closest match
        $faces = Face::all();
        $bestMatch = null;
        $bestDistance = PHP_FLOAT_MAX;

        foreach ($faces as $face) {
            $distance = $this->cosineDistance($inputEmbedding, $face->embedding);
            if ($distance < $bestDistance && $distance < 0.5) { // Threshold
                $bestDistance = $distance;
                $bestMatch = $face;
            }
        }

        if ($bestMatch) {
            return response()->json([
                'recognized' => true,
                'user_id' => $bestMatch->user_id,
                'confidence' => 1 - $bestDistance,
            ]);
        }

        return response()->json([
            'recognized' => false,
            'message' => 'Face not recognized',
        ]);
    }

    private function cosineDistance($a, $b)
    {
        $dotProduct = 0;
        $normA = 0;
        $normB = 0;

        for ($i = 0; $i < count($a); $i++) {
            $dotProduct += $a[$i] * $b[$i];
            $normA += $a[$i] * $a[$i];
            $normB += $b[$i] * $b[$i];
        }

        $normA = sqrt($normA);
        $normB = sqrt($normB);

        return 1 - ($dotProduct / ($normA * $normB));
    }
}
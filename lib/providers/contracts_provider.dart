import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/firestore_service.dart';

final studentContractsProvider = FutureProvider<List<Contract>>((ref) async {
  if (ref.read(authStateProvider).role != 'STUDENT') {
    throw Exception("wrong role");
  }
  final firebaseFirestore = FirestoreService();

  final contractIds = await firebaseFirestore.getContractIdsForStudent(
      ref.read(authStateProvider).account!.studentRef!);

  final contractsJson =
      await firebaseFirestore.getContractsByContractIds(contractIds);

  final contracts =
      contractsJson.map((e) => Contract.fromFireStore(e)).toList();
  return contracts;
});

final tutorContractsProvider = FutureProvider<List<Contract>>((ref) async {
  if (ref.read(authStateProvider).role != 'TUTOR') {
    throw Exception("wrong role");
  }
  final firebaseFirestore = FirestoreService();

  final contractIds = await firebaseFirestore
      .getContractIdsForTutor(ref.read(authStateProvider).account!.tutorRef!);

  final contractsJson =
      await firebaseFirestore.getContractsByContractIds(contractIds);

  final contracts =
      contractsJson.map((e) => Contract.fromFireStore(e)).toList();
  return contracts;
});
